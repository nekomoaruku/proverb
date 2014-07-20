#import "I3ThinkKotobaLogoView.h"

@interface I3ThinkKotobaLogoView ()

@property UILabel *kotobaLabel;
@property int number;

@end

@implementation I3ThinkKotobaLogoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.kotobaLabel = [self _createLogoLabel];
        [self addSubview:self.kotobaLabel];
    }
    return self;
}

- (UILabel *)_createLogoLabel
{
    UILabel *label = [[UILabel alloc] init];
    
    NSDictionary *blackFontAttributes =
        @{NSForegroundColorAttributeName:[UIColor blackColor],
          NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]};
    NSDictionary *greenFontAttributes =
        @{NSForegroundColorAttributeName:[UIColor colorWithRed:(140/255.0f)
                                                         green:(198/255.0f)
                                                          blue:(62/255.0f) alpha:1],
          NSFontAttributeName:[UIFont boldSystemFontOfSize:18.0f]};
    
    NSAttributedString *th =
        [[NSAttributedString alloc] initWithString:@"TH" attributes:blackFontAttributes];
    NSAttributedString *i =
        [[NSAttributedString alloc] initWithString:@"I" attributes:greenFontAttributes];
    NSAttributedString *nk =
        [[NSAttributedString alloc] initWithString:@"NK\n" attributes:blackFontAttributes];
    NSAttributedString *kotoba =
        [[NSAttributedString alloc] initWithString:@"KOTOBA" attributes:greenFontAttributes];
    
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] init];
    [attrText appendAttributedString:th];
    [attrText appendAttributedString:i];
    [attrText appendAttributedString:nk];
    [attrText appendAttributedString:kotoba];
    
    label.numberOfLines = 0;
    label.attributedText = attrText;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    
    return label;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.kotobaLabel.center = CGPointMake(self.frame.size.width * 0.5f,
                                        self.frame.size.height * 0.5f);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
