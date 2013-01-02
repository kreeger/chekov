#import <UIKit/UIKit.h>

@interface UITableViewCell (Awesome)

+ (void)registerForTableView:(UITableView *)tableView;
+ (NSString *)cellId;

@end
