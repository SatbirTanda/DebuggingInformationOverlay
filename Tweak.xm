#define TWEAK "com.sst1337.DebuggingInformationOverlay"
#define PLIST_FILENAME @"/var/mobile/Library/Preferences/com.sst1337.DebuggingInformationOverlay.plist"
#define PLIST_NOTIFICATION "com.sst1337.DebuggingInformationOverlay/settingsupdated"

static NSMutableArray *enabledApps = NULL;

static void loadEnabledApps()
{
	CFPreferencesAppSynchronize(CFSTR(TWEAK));
	if (enabledApps == NULL)
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

static void reloadSettingsNotification(CFNotificationCenterRef notificationCenterRef, void * arg1, CFStringRef arg2, const void * arg3, CFDictionaryRef dictionary)
{
	loadEnabledApps();
}

%group iOS10
%hook UIApplication //  Hook to selected Apps

- (id)init
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLaunch:)
        name:UIApplicationDidFinishLaunchingNotification object:nil];
    return %orig;
}

%new
- (void)onLaunch:(NSNotification *)notifcation
{ 	
	if (enabledApps == NULL)
		loadEnabledApps();

    NSString *topApplication = [[[NSBundle mainBundle] bundleIdentifier] lowercaseString];

 	for(int i = 0; i < enabledApps.count; i++)
 	{
 		if([enabledApps[i] isEqualToString: topApplication])
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
    }
}