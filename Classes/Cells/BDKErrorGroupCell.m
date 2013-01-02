#import "BDKErrorGroupCell.h"
#import "AirbrakeGroup.h"

#import <QuartzCore/QuartzCore.h>

#define kCellPadding 9.0f

@interface BDKErrorGroupCell ()

@property (strong, nonatomic) UILabel *groupName;
@property (strong, nonatomic) UILabel *errorLocation;
@property (strong, nonatomic) UILabel *errorDetail;
// @property (strong, nonatomic) UILabel *errorCount;

@end

@implementation BDKErrorGroupCell

- (id)init {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIDErrorGroup];
    return self;
}

+ (NSString *)cellId {
    return kCellIDErrorGroup;
}

#pragma mark - Properties

- (void)setGroup:(AirbrakeGroup *)group {
    self.accessoryType = group ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    self.groupName.text = group.errorClass;
    self.errorLocation.text = group.location;
    self.errorDetail.text = group.errorMessage;
    // self.accessoryView = self.errorCount;
    CGPoint origin = self.bounds.origin;
    
    [self.groupName sizeToFit];
    CGRect frame = CGRectIntegral(self.groupName.frame);
    frame.origin = CGPointMake(origin.x + kCellPadding, origin.y + kCellPadding);
    self.groupName.frame = frame;
    
    [self.errorLocation sizeToFit];
    frame = CGRectIntegral(self.errorLocation.frame);
    frame.origin = CGPointMake(self.groupName.frame.origin.x, CGRectGetMaxY(self.groupName.frame));
    self.errorLocation.frame = frame;
    
    [self.errorDetail sizeToFit];
    frame = CGRectIntegral(self.errorDetail.frame);
    frame.origin = CGPointMake(self.groupName.frame.origin.x, CGRectGetMaxY(self.errorLocation.frame));
    frame.size.width = kCellErrorGroupLabelWidth;
    self.errorDetail.frame = frame;
    
//    self.errorCount.text = [NSString stringWithFormat:@"%@", group.noticesCount];
//    self.errorCount.backgroundColor = [UIColor grayColor];
//    [self.errorCount sizeToFit];
//    self.errorCount.frame = CGRectInset(CGRectIntegral(self.errorCount.frame), -6.0f, -4.0f);
    
    self.height = CGRectGetMaxY(self.errorDetail.frame) + kCellPadding;
}

- (UILabel *)groupName {
    if (_groupName != nil) return _groupName;
    _groupName = [[UILabel alloc] initWithFrame:CGRectZero];
    _groupName.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:_groupName];
    return _groupName;
}

- (UILabel *)errorLocation {
    if (_errorLocation != nil) return _errorLocation;
    _errorLocation = [[UILabel alloc] initWithFrame:CGRectZero];
    _errorLocation.font = [UIFont systemFontOfSize:12];
    [self addSubview:_errorLocation];
    return _errorLocation;
}

- (UILabel *)errorDetail {
    if (_errorDetail != nil) return _errorDetail;
    _errorDetail = [[UILabel alloc] initWithFrame:CGRectMake(kCellPadding, kCellPadding, kCellErrorGroupLabelWidth, 400)];
    _errorDetail.numberOfLines = 0;
    _errorDetail.lineBreakMode = NSLineBreakByWordWrapping;
    _errorDetail.font = [UIFont systemFontOfSize:12];
    _errorDetail.textColor = [UIColor grayColor];
    [self addSubview:_errorDetail];
    return _errorDetail;
}

//- (UILabel *)errorCount {
//    if (_errorCount != nil) return _errorCount;
//    _errorCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 32.0f)];
//    _errorCount.textColor = [UIColor whiteColor];
//    _errorCount.layer.cornerRadius = 8.0f;
//    _errorCount.font = [UIFont boldSystemFontOfSize:13];
//    _errorCount.textAlignment = NSTextAlignmentCenter;
//    return _errorCount;
//}

@end
