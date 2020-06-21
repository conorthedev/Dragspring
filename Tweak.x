#import "Tweak.h"
#include <spawn.h>

NSUserDefaults *defaults;

BOOL enabled;
BOOL shouldShowText;
BOOL delayForSecond;

int command;

NSString *subtitleBefore;
NSString *subtitleDuring;
NSString *customCommand;

static PSUIPrefsListController *globalController;

void runCommand();

%hook PSUIPrefsListController
%property (nonatomic, strong) UIRefreshControl *dragspringRefreshControl;

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    [self _dragspringUpdateRefreshControl];
}

%new
- (void)_dragspringUpdateRefreshControl {
    if(enabled) {
        [self _dragspringMakeRefreshControl];
        self.table.refreshControl = self.dragspringRefreshControl;
    } else {
        self.dragspringRefreshControl = NULL;
        self.table.refreshControl = NULL;
    }
}

%new
- (void)_dragspringMakeRefreshControl {
    self.dragspringRefreshControl = [UIRefreshControl new];

    if(shouldShowText) {
        self.dragspringRefreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:subtitleBefore];
    }

    [self.dragspringRefreshControl addTarget:self action:@selector(_dragspringRunCommand) forControlEvents:UIControlEventValueChanged];
}

%new
- (void)_dragspringRunCommand {
    if(shouldShowText) {
        self.dragspringRefreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:subtitleDuring];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(delayForSecond) {
            [NSThread sleepForTimeInterval:1];  
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSTask *task = [[NSTask alloc] init];

            switch (command) {
                case 0:
                    [task setLaunchPath:@"/usr/bin/sbreload"];
                    [task setArguments:@[]];
                    break;
                case 1:
                    [task setLaunchPath:@"/usr/bin/uicache"];
                    [task setArguments:@[@"-a"]];
                    break;
                case 2:
                    [task setLaunchPath:@"/usr/bin/sreboot"];
                    [task setArguments:@[]];
                    break;
                case 3:
                    [task setLaunchPath:@"/bin/sh"];
                    [task setArguments:@[@"-c", customCommand]];
                    break;
            }

            [task setTerminationHandler:^(NSTask* task) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self.dragspringRefreshControl endRefreshing];
                    });
                }];
            [task launch];
        });
    });
    
}
%end

void ReloadPrefs() {
    defaults = [[NSUserDefaults alloc] initWithSuiteName:@"me.conorthedev.dragspring.prefs"];
    [defaults registerDefaults:@{ @"enabled" : @YES, @"delayForSecond": @YES, @"appearance" : @0, @"subtitleBefore": @"Respring?", @"subtitleAfter": @"Respringing...", @"command": @0, @"customCommand": @"/usr/bin/sbreload" }];
    
    enabled = [[defaults objectForKey:@"enabled"] boolValue];
    delayForSecond = [[defaults objectForKey:@"delayForSecond"] boolValue];
    shouldShowText = [[defaults objectForKey:@"appearance"] intValue];
    subtitleBefore = [[defaults objectForKey:@"subtitleBefore"] stringValue];
    subtitleDuring = [[defaults objectForKey:@"subtitleAfter"] stringValue];
    command = [[defaults objectForKey:@"command"] intValue];
    customCommand = [[defaults objectForKey:@"customCommand"] stringValue];

    if(globalController) {
        [globalController _dragspringUpdateRefreshControl];
    }
}

%ctor {
    ReloadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)ReloadPrefs, CFSTR("me.conorthedev.dragspring/ReloadPreferences"), NULL, kNilOptions);

    %init;
}
