#import "BDKTableViewCell.h"

#define kCellIDErrorGroup @"ErrorGroupCell"
#define kCellErrorGroupLabelWidth 280.0f

@class AirbrakeGroup;

@interface BDKErrorGroupCell : BDKTableViewCell

@property (strong, nonatomic) AirbrakeGroup *group;

@end
