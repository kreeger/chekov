#import "BDKNoticeCell.h"
#import "AirbrakeNotice.h"

@implementation BDKNoticeCell

- (id)init {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIDNotice];
    return self;
}

+ (NSString *)cellId {
    return kCellIDNotice;
}

#pragma mark - Properties

- (void)setNotice:(AirbrakeNotice *)notice {
    self.accessoryType = notice ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    self.textLabel.text = [notice.createdAt stringFromDateWithFormat:@"yyyy-MM-dd hh:mm:ss a"];
    self.textLabel.font = [UIFont systemFontOfSize:16];
    _notice = notice;
}

@end
