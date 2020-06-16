#import <Preferences/PSEditableTableCell.h>
#import <libappearancecell/libappearancecell.h>
#import <CTDPrefs/CTDPrefs.h>

@interface DSRootListController : CTDListController
@end

@interface DSReturnTextCell : PSEditableTableCell
- (BOOL)textFieldShouldReturn:(id)textField;
@end
