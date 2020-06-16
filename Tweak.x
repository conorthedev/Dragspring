NSUserDefaults *defaults;
BOOL enabled;

void ReloadPrefs() {
    defaults = [[NSUserDefaults alloc] initWithSuiteName:@"me.conorthedev.dragspring.prefs"];
    [defaults registerDefaults:@{ @"enabled" : @YES }];
    
    enabled = [[defaults objectForKey:@"enabled"] boolValue];
}

%ctor {
    ReloadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)ReloadPrefs, CFSTR("me.conorthedev.dragspring/ReloadPreferences"), NULL, kNilOptions);

    %init;
}