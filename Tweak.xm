#define PLIST_FILENAME @"/var/mobile/Library/Preferences/com.sst1337.DebuggingInformationOverlay.plist"

%ctor 
{
	NSString *identifier = [NSBundle mainBundle].bundleIdentifier;
	NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_FILENAME];	
	if ([[plistDict objectForKey:[ALSettingsKeyPrefix stringByAppendingString:identifier]] boolValue]) 
	{
		%init(someGroup);
	}
}