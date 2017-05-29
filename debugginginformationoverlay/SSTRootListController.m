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

- (void)linkToMyTwitter 
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/sst1337/"]];
} 

@end