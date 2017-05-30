#include "SSTRootListController.h"

@implementation SSTRootListController

- (NSArray *)specifiers 
{
	if (!_specifiers) 
	{
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)respring 
{
    system("killall -9 SpringBoard");
} 

- (void)linkToBlog 
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ryanipete.com/blog/ios/swift/objective-c/uidebugginginformationoverlay/"]];
} 

- (void)linkToMyTwitter 
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/sst1337/"]];
} 

@end