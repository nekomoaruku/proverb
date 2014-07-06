#import "I3StampButton.h"

@interface I3StampButton ()

@property UIButton *stampButton;

@end

@implementation I3StampButton

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame number:0 answerState:false];
}

- (id)initWithFrame:(CGRect)frame number:(int)number answerState:(bool)answered
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // ボタンを生成
        self = [UIButton buttonWithType:UIButtonTypeCustom];
        self.frame = frame;
        
        // 画像を設定
        NSString *stampImageName = answered ? @"balloonB" : @"balloonA";
        UIImage *stampImage = [UIImage imageNamed:stampImageName];
        [self setBackgroundImage:stampImage forState:UIControlStateNormal];
        [self setTitle:[NSString stringWithFormat:@"%d", number]
                          forState:UIControlStateNormal];
        
        // タイトルを設定
        if (answered) {
            UIColor *titleColor = [UIColor colorWithRed:171.0f/255.0f
                                                  green:218.0f/255.0f
                                                   blue:229.0f/255.0f
                                                  alpha:1.0];
            [self setTitleColor:titleColor forState:UIControlStateNormal];
            [self.titleLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:22.8f]];
            self.titleEdgeInsets = UIEdgeInsetsMake(-12, 0, 0, 0);
        }
        
        // 未回答の場合は、buttonを無効に
        if (!answered) {
            self.userInteractionEnabled = NO;
        }
    }
    return self;
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
