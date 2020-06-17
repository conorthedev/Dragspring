#import <Preferences/PSListController.h>
#import <Preferences/PSEditableTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <libappearancecell/libappearancecell.h>

@interface DSSettingsController : PSListController

@property (nonatomic, retain) NSMutableDictionary *required;

@end

@interface DSReturnTextCell : PSEditableTableCell
- (BOOL)textFieldShouldReturn:(id)textField;
@end
