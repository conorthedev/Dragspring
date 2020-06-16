#import "Tweak.h"

NSUserDefaults *defaults;
BOOL enabled;
BOOL shouldShowText;
BOOL hapticFeedback;
NSString *subtitleBefore;
NSString *subtitleDuring;
NSString *command;

static PSUIPrefsListController *globalController;

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
    %log;
    if(hapticFeedback) {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
        [generator prepare];
        [generator impactOccurred]; 
        generator = nil;
	}

    NSMutableArray *arguments = [[command componentsSeparatedByString:@" "] mutableCopy];
    NSString *command = arguments[0];

    [arguments removeObject:command];
    
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:command];
    [task setArguments:arguments];
    [task setTerminationHandler:^(NSTask* task) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dragspringRefreshControl endRefreshing];
        });
    }];
    [task launch];
}
%end

void ReloadPrefs() {
    defaults = [[NSUserDefaults alloc] initWithSuiteName:@"me.conorthedev.dragspring.prefs"];
    [defaults registerDefaults:@{ @"enabled" : @YES, @"hapticFeedback": @YES, @"appearance" : @0, @"subtitleBefore": @"Respring!", @"subtitleAfter": @"Respringing...", @"command": @"/usr/bin/sbreload" }];
    
    enabled = [[defaults objectForKey:@"enabled"] boolValue];
    hapticFeedback = [[defaults objectForKey:@"hapticFeedback"] boolValue];
    shouldShowText = [[defaults objectForKey:@"appearance"] intValue];
    subtitleBefore = [[defaults objectForKey:@"subtitleBefore"] stringValue];
    subtitleDuring = [[defaults objectForKey:@"subtitleAfter"] stringValue];
    command = [[defaults objectForKey:@"command"] stringValue];
    
    if(globalController) {
        [globalController _dragspringUpdateRefreshControl];
    }
}

%ctor {
    ReloadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)ReloadPrefs, CFSTR("me.conorthedev.dragspring/ReloadPreferences"), NULL, kNilOptions);

    %init;
}
