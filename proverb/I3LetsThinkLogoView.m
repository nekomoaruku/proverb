#import "I3LetsThinkLogoView.h"

@interface I3LetsThinkLogoView ()

@property UILabel *letsThinkLabel;
@property UIImageView *balloon;

@end

@implementation I3LetsThinkLogoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.letsThinkLabel = [self _createLetsThinkLabel];
        [self addSubview:self.letsThinkLabel];
        self.balloon = [self _createBallon];
        [self addSubview:self.balloon];
    }
    return self;
}

- (UILabel *)_createLetsThinkLabel
{
    UILabel *label = [[UILabel alloc] init];
    
    NSDictionary *normalFontAttributes =
        @{NSForegroundColorAttributeName:[UIColor blackColor],
          NSFontAttributeName:[UIFont fontWithName:@"HiraKakuProN-W3" size:22.0f]};
    NSDictionary *invisibleWordFontAttributes =
        @{NSForegroundColorAttributeName:[UIColor colorWithRed:(167/255.0f)
                                                         green:(169/255.0f)
                                                          blue:(171/255.0f) alpha:1],
          NSFontAttributeName:[UIFont fontWithName:@"HiraKakuProN-W3" size:24.0f]};
    
    NSAttributedString *kotoba =
        [[NSAttributedString alloc] initWithString:@"KOTOBAの" attributes:normalFontAttributes];
    NSAttributedString *invisible =
        [[NSAttributedString alloc] initWithString:@"●●" attributes:invisibleWordFontAttributes];
    NSAttributedString *think =
        [[NSAttributedString alloc] initWithString:@"を考えよう" attributes:normalFontAttributes];
    
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] init];
    [attrText appendAttributedString:kotoba];
    [attrText appendAttributedString:invisible];
    [attrText appendAttributedString:think];
    
    label = [[UILabel alloc] init];
    label.attributedText = attrText;
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    
    return label;
}

- (UIImageView *)_createBallon
{
    UIImage *balloon = [UIImage imageNamed:@"balloon.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:balloon];
    [imageView sizeToFit];
    return imageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = CGRectZero;
    
    rect = self.balloon.bounds;
    rect.origin = CGPointMake(self.frame.size.width/2 - self.balloon.frame.size.width/2, 0);
    self.balloon.frame = rect;
    
    rect = self.letsThinkLabel.bounds;
    rect.origin = CGPointMake(self.frame.size.width/2 - self.letsThinkLabel.frame.size.width/2,
                              self.balloon.frame.size.height + 8);
    self.letsThinkLabel.frame = rect;
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
