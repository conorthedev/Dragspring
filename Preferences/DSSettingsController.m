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
		self.required = (!self.required) ? [NSMutableDictionary new] : self.required;

		for (PSSpecifier *specifier in _specifiers) {
			if ([specifier propertyForKey:@"requires"]) {
				[self.required setObject:@0 forKey:[specifier propertyForKey:@"requires"]];
			}
		}

		for (PSSpecifier *specifier in _specifiers) {
			if ([self.required objectForKey:[specifier propertyForKey:@"key"]]) {
				[self.required setObject:[self readPreferenceValue:specifier] forKey:[specifier propertyForKey:@"key"]];
			}
		}
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

- (CGFloat)tableView:(UITableView *)view heightForRowAtIndexPath:(NSIndexPath *)path {
    PSSpecifier *specifier = [self specifierAtIndexPath:path];
    if ([specifier propertyForKey:@"requires"]) {
        if ([[self.required objectForKey:[specifier propertyForKey:@"requires"]] integerValue] != 3) {
            return 0.01;
        }
    }

    return [super tableView:view heightForRowAtIndexPath:path];
}

- (void)tableView:(UITableView *)view willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)path {
	cell.clipsToBounds = YES;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    [super setPreferenceValue:value specifier:specifier];
	if ([specifier propertyForKey:@"key"] && [self.required objectForKey:[specifier propertyForKey:@"key"]]) {
		[self.required setObject:value forKey:[specifier propertyForKey:@"key"]];
		[[self valueForKey:@"_table"] beginUpdates];
		[[self valueForKey:@"_table"] endUpdates];
	}
}

@end    

@implementation DSReturnTextCell

- (BOOL)textFieldShouldReturn:(id)textField {
    return YES;
}

@end
