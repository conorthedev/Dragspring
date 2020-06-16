#include "DSSettingsController.h"

NSUserDefaults *defaults;

@implementation DSSettingsController

- (DSSettingsController *)init {
    self = [super init];

    if (self) {
        defaults = [[NSUserDefaults alloc] initWithSuiteName:@"me.conorthedev.dragspring.prefs"];
        [defaults registerDefaults:@{ @"enabled" : @YES, @"delayForSecond": @YES, @"appearance" : @0, @"subtitleBefore": @"Respring?", @"subtitleAfter": @"Respringing...", @"command": @"/usr/bin/sbreload" }];

        UISwitch *toggleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [toggleSwitch setOn:[[defaults objectForKey:@"enabled"] boolValue] animated:NO];
        [toggleSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventTouchUpInside];

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toggleSwitch];
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

- (void)switchToggled:(UISwitch *)sender {
    [defaults setBool:[sender isOn] forKey:@"enabled"];  
    [defaults synchronize];   
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.conorthedev.dragspring/ReloadPreferences"), NULL, NULL, TRUE);        
}

@end

@implementation DSReturnTextCell

- (BOOL)textFieldShouldReturn:(id)textField {
    return YES;
}

@end
