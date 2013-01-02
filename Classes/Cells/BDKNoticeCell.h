#import "BDKTableViewCell.h"

#define kCellIDNotice @"NoticeCell"

@class AirbrakeNotice;

@interface BDKNoticeCell : BDKTableViewCell

@property (strong, nonatomic) AirbrakeNotice *notice;

@end
