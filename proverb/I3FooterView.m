#import "I3FooterView.h"

@interface I3FooterView ()

@property UIImageView *wavyLine;
@property UIButton *infoButton;
@property UIButton *leftButton;
@property UIButton *centerButton;

@end

// 定数
static const float I3FotterHeight = 60.0f;

@implementation I3FooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.wavyLine = [self _createWavyLine];
        self.infoButton = [self _createInfoButton];
        self.centerButton = [self _createCenterButton];
        self.leftButton = [self _createLeftButton];
        [self addSubview:self.wavyLine];
        [self addSubview:self.infoButton];
        [self addSubview:self.centerButton];
        [self addSubview:self.leftButton];
    }
    return self;
}

- (UIImageView *)_createWavyLine
{
    UIImage *wavyLine = [UIImage imageNamed:@"waveLine"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:wavyLine];
    [imageView sizeToFit];
    return imageView;
}

- (UIButton *)_createInfoButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *infoIcon = [UIImage imageNamed:@"infoIcon"];
    [button setImage:infoIcon forState:UIControlStateNormal];
    button.tag = 2;
    [button addTarget:self action:@selector(_footerButtonTouched:)
        forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return button;
}

- (UIButton *)_createCenterButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.tag = 1;
    [button addTarget:self action:@selector(_footerButtonTouched:)
        forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UIButton *)_createLeftButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.tag = 0;
    [button addTarget:self action:@selector(_footerButtonTouched:)
        forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)_footerButtonTouched:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
            [self.delegate footerViewLeftButtonTouched:self];
            break;
        case 1:
            [self.delegate footerViewCenterButtonTouched:self];
            break;
        case 2:
            [self.delegate footerViewInfoButtonTouched:self];
            break;
        default:
            break;
    }
}

- (void)setLeftButtonTitle:(NSString *)leftButtonTitle
{
    [self.leftButton setTitle:leftButtonTitle forState:UIControlStateNormal];
    [self.leftButton sizeToFit];
    [self setNeedsLayout];
}

- (void)setCenterButtonTitle:(NSString *)centerButtonTitle
{
    [self.centerButton setTitle:centerButtonTitle forState:UIControlStateNormal];
    [self.centerButton sizeToFit];
    [self setNeedsLayout];
}

- (void)setInfoButtonVisibility:(bool)visible
{
    self.infoButton.hidden = !visible;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = CGRectZero;
    UIView *parentView = [self superview];
    
    self.frame = CGRectMake(0,
                            parentView.frame.size.height - I3FotterHeight,
                            parentView.frame.size.width,
                            I3FotterHeight);
    
    rect = self.frame;
    rect = self.wavyLine.frame;
    self.wavyLine.frame = CGRectMake(0, 0,
                                     parentView.frame.size.width, rect.size.height);
    rect = self.infoButton.frame;
    self.infoButton.frame = CGRectMake(parentView.frame.size.width - 38.0f, 18.0f,
                                       rect.size.width, rect.size.height);
    rect = self.leftButton.frame;
    self.leftButton.frame = CGRectMake(12.0f, 18.0f,
                                       rect.size.width, rect.size.height);
    rect = self.centerButton.frame;
    self.centerButton.center = CGPointMake(parentView.frame.size.width / 2,
                                           rect.size.height / 2 + 18.0f);
}

@end
