#import <UIKit/UIKit.h>

@interface BDKBaseTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

+ (id)controllerWithStyle:(UITableViewStyle)style;
- (id)initWithStyle:(UITableViewStyle)style;
- (void)refreshViewWithRefreshControl:(SVPullToRefreshView *)pullToRefreshView;
- (void)timestampRefreshControl;

@end
