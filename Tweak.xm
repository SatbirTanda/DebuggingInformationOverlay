#import <AppList/AppList.h>

#define PLIST_FILENAME @"/var/mobile/Library/Preferences/com.sst1337.DebuggingInformationOverlay.plist"

@interface UIApplication
- (void)showUIDebuggingInformationOverlay;
@end

%group iOS10
%hook UIApplication //  Hook to selected Apps

%new
- (void)showDebuggingInformationOverlay
{
    id debuggingInformationOverlay = NSClassFromString(@"UIDebuggingInformationOverlay");
    [debuggingInformationOverlay performSelector: NSSelectorFromString(@"prepareDebuggingOverlay")];
    id debuggingInformationOverlayWindow = [debuggingInformationOverlay performSelector: NSSelectorFromString(@"overlay")];
    [debuggingInformationOverlayWindow performSelector: NSSelectorFromString(@"toggleVisibility")];
}

- (void)init 
{

    return %orig;
}

%end
%end

%ctor 
{
	if(kCFCoreFoundationVersionNumber >= 1300) // iOS 10
    {
	    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];

	    // Either this or whatever works from link after this
	    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_FILENAME];    
	    if ([[plistDict objectForKey:bundleID] boolValue]) 
	    {
	        %init(iOS10);
	    }

    	// NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];

	    // CFPreferencesAppSynchronize(CFSTR(TWEAK));
	    // CFPropertyListRef value = CFPreferencesCopyAppValue(CFSTR(bundleID), CFSTR(TWEAK));
	    // if(value == nil) return NO;  
	    // [CFBridgingRelease(value) boolValue];

	    // // Either this or whatever works from link after this
	    // if ([CFBridgingRelease(value) boolValue]) 
	    // {
	    //     %init(iOS10);
	    // }

    }
}