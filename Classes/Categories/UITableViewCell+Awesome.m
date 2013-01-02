#import "UITableViewCell+Awesome.h"

@implementation UITableViewCell (Awesome)

+ (void)registerForTableView:(UITableView *)tableView {
    [tableView registerClass:[self class] forCellReuseIdentifier:self.cellId];
}

+ (NSString *)cellId {
    return kDefaultCellId;
}

@end
