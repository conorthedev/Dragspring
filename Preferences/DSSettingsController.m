#include "DSSettingsController.h"

@implementation DSSettingsController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)code {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/cbyrne/Dragspring"] options:@{} completionHandler:nil];
}

- (void)bug {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/cbyrne/Dragspring/issues/new"] options:@{} completionHandler:nil];
}

@end

@implementation DSReturnTextCell

- (BOOL)textFieldShouldReturn:(id)textField {
    return YES;
}

@end