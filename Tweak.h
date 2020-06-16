#import <Preferences/PSListController.h>
#import "Headers/NSTask.h"

@interface PSListController (Private)
- (UITableView *)table;
@end

@interface PSUIPrefsListController : PSListController
@end

@interface PSUIPrefsListController (Dragspring)
@property (nonatomic, strong) UIRefreshControl *dragspringRefreshControl;

- (void)_dragspringUpdateRefreshControl;
- (void)_dragspringRunCommand;
- (void)_dragspringMakeRefreshControl;
@end