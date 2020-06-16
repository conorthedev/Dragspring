#import <Preferences/PSListController.h>
#import <Preferences/PSEditableTableCell.h>
#import <libappearancecell/libappearancecell.h>

@interface DSSettingsController : PSListController
@end

@interface DSReturnTextCell : PSEditableTableCell
- (BOOL)textFieldShouldReturn:(id)textField;
@end
