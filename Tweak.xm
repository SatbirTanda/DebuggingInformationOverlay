#import <AppList/AppList.h>

#define PLIST_FILENAME @"/var/mobile/Library/Preferences/com.sst1337.DebuggingInformationOverlay.plist"

%group GROUP_NAME_A

%end

%ctor 
{
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];

    // Either this or whatever works from link after this
    NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_FILENAME];    
    if ([[plistDict objectForKey:bundleID] boolValue]) 
    {
        %init(GROUP_NAME_A);
    }
}