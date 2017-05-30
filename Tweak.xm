#define TWEAK "com.sst1337.DebuggingInformationOverlay"
#define PLIST_FILENAME @"/var/mobile/Library/Preferences/com.sst1337.DebuggingInformationOverlay.plist"
#define PLIST_NOTIFICATION "com.sst1337.DebuggingInformationOverlay/settingsupdated"

static NSMutableArray *enabledApps = nil;

static void reloadSettingsNotification(CFNotificationCenterRef notificationCenterRef, void * arg1, CFStringRef arg2, const void * arg3, CFDictionaryRef dictionary)
{
	CFPreferencesAppSynchronize(CFSTR(TWEAK));
	if (!enabledApps)
	enabledApps = [[NSMutableArray alloc] init];

    [enabledApps removeAllObjects];

    NSDictionary * settingsPlist = [NSDictionary dictionaryWithContentsOfFile:PLIST_FILENAME];

    [settingsPlist enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) 
    {
        if ([key hasPrefix:@"ALValue-"]) 
        {
            if ([obj boolValue]) 
            {
                [enabledApps addObject:[[key substringFromIndex:[@"ALValue-" length]] lowercaseString]];
            }
        }
    }];

    CFPropertyListRef value = CFPreferencesCopyAppValue(CFSTR("EnableOnSpringBoard"), CFSTR(TWEAK));
    if(value == nil) return;  
    else if([CFBridgingRelease(value) boolValue])
    {
    	[enabledApps addObject:@"com.apple.springboard"];
    }
}

%group iOS10
%hook SBApplication //  Hook to selected Apps

- (void)willActivate
 {
 	%orig;

 	if(enabledApps == nil) return;
 	NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
 	for(int i = 0; i < enabledApps.count; i++)
 	{
	 	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:enabledApps[i]  
                                    message:bundleID
                                    delegate:nil 
                                    cancelButtonTitle:@"OK" 
                                    otherButtonTitles:nil];
    	[alert show];
 		if([enabledApps[i] isEqualToString: bundleID])
 		{
		    id debuggingInformationOverlay = NSClassFromString(@"UIDebuggingInformationOverlay");
		    [debuggingInformationOverlay performSelector: NSSelectorFromString(@"prepareDebuggingOverlay")];
		    id debuggingInformationOverlayWindow = [debuggingInformationOverlay performSelector: NSSelectorFromString(@"overlay")];
		    [debuggingInformationOverlayWindow performSelector: NSSelectorFromString(@"toggleVisibility")];
 		}
 	}
}

%end
%end

%ctor 
{
	if(kCFCoreFoundationVersionNumber >= 1300) // iOS 10
    {
    	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadSettingsNotification, CFSTR(PLIST_NOTIFICATION), NULL, CFNotificationSuspensionBehaviorCoalesce);
    	%init(iOS10);


	    // NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];

	    // // Either this or whatever works from link after this
	    // NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_FILENAME];    
	    // if ([[plistDict objectForKey:bundleID] boolValue]) 
	    // {
	    //     %init(iOS10);
	    // }

    	// // NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];

	    // // CFPreferencesAppSynchronize(CFSTR(TWEAK));
	    // // CFPropertyListRef value = CFPreferencesCopyAppValue(CFSTR(bundleID), CFSTR(TWEAK));
	    // // if(value == nil) return NO;  
	    // // [CFBridgingRelease(value) boolValue];

	    // // // Either this or whatever works from link after this
	    // // if ([CFBridgingRelease(value) boolValue]) 
	    // // {
	    // //     %init(iOS10);
	    // // }

    }
}