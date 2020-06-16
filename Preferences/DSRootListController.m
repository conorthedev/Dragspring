#include "DSRootListController.h"

@implementation DSRootListController

- (DSRootListController *)init {
	self = [super init];

	if (self) {
		CTDPreferenceSettings *preferenceSettings = [[CTDPreferenceSettings alloc] init];
		preferenceSettings.customizeNavbar = YES;
		preferenceSettings.tintColor = [UIColor colorWithRed:100.0f / 255.0f
													   green:82.0f / 255.0f
														blue:189.0f / 255.0f
													   alpha:1];
		preferenceSettings.barTintColor = preferenceSettings.tintColor;
		preferenceSettings.headerTextColor = [UIColor whiteColor];

		self.preferenceSettings = preferenceSettings;
    }

    return self;
}

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