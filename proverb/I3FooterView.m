#import "I3FooterView.h"

@interface I3FooterView ()

@property UIImageView *wavyLine;

@end

// 定数
static const float I3FotterHeight = 60.0f;

@implementation I3FooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.wavyLine = [self _createWavyLine];
        self.infoButton = [self _infoButton];
        [self addSubview:self.wavyLine];
        [self addSubview:self.infoButton];
    }
    return self;
}

- (UIImageView *)_createWavyLine
{
    UIImage *wavyLine = [UIImage imageNamed:@"wavyLine"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:wavyLine];
    [imageView sizeToFit];
    return imageView;
}

- (UIButton *)_infoButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *infoIcon = [UIImage imageNamed:@"infoIcon"];
    [button setImage:infoIcon forState:UIControlStateNormal];
    [button sizeToFit];
    return button;
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
    self.wavyLine.frame = CGRectMake(0,
                                     0,
                                     parentView.frame.size.width,
                                     rect.size.height);
    rect = self.infoButton.frame;
    self.infoButton.frame = CGRectMake(10.0f,
                                       20.0f,
                                       rect.size.width,
                                       rect.size.height);
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
