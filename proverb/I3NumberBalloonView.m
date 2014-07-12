#import "I3NumberBalloonView.h"

@interface I3NumberBalloonView ()

@property UIImageView *numberBalloon;
@property UILabel *quizNumberLabel;

@end


@implementation I3NumberBalloonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberBalloon = [self _createNumberBalloon];
        self.quizNumberLabel = [self _createQuizNumberLabel];
        
        CGRect rect= self.numberBalloon.frame;
        self.quizNumberLabel.frame = rect;

        self.numberBalloon.center = CGPointMake(0, 0);
        self.quizNumberLabel.center = CGPointMake(0, 0);
        
        [self addSubview:self.numberBalloon];
        [self addSubview:self.quizNumberLabel];
    }
    return self;
}

- (UIImageView *)_createNumberBalloon
{
    UIImage *numberBalloon = [UIImage imageNamed:@"numberBalloon"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:numberBalloon];
    [imageView sizeToFit];
    return imageView;
}

- (UILabel *)_createQuizNumberLabel
{
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectZero];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize:25.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0.721 green:0.878 blue:0.917 alpha:1.0];
    return label;
}

- (void)setViewDataWithQuizData:(NSDictionary *)quizData
{
    self.quizNumberLabel.text = [quizData[@"number"] stringValue];
    
    [self setNeedsLayout];
}

@end