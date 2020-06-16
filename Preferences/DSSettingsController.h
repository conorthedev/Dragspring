#import <Preferences/PSEditableTableCell.h>
#import <libappearancecell/libappearancecell.h>
#import "SkittyPrefs/SPSettingsController.h"

@interface DSSettingsController : SPSettingsController
@end

@interface DSReturnTextCell : PSEditableTableCell
- (BOOL)textFieldShouldReturn:(id)textField;
@end
