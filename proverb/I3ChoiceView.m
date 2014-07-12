#import "I3ChoiceView.h"

@interface I3ChoiceView ()

@property UILabel *choiceNumberLabel;
@property UILabel *choiceStringLabel;
@property UIImageView *checkMark;

@end

@implementation I3ChoiceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.choiceNumberLabel = [self _createChoiceNumberLabel];
        [self addSubview:self.choiceNumberLabel];
        
        self.choiceStringLabel = [self _createChoiceStringLabel];
        [self addSubview:self.choiceStringLabel];
        
        self.checkMark = [self _createCheckMark];
        [self addSubview:self.checkMark];
    }
    return self;
}

- (UILabel *)_createChoiceNumberLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:22.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];

    label.layer.borderColor = [UIColor whiteColor].CGColor;
    label.layer.borderWidth = 1.0;
    [label.layer setCornerRadius:10.0f];
    
    return label;
}

-(UILabel *)_createChoiceStringLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15.0f];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    label.layer.borderColor = [UIColor whiteColor].CGColor;
    
    return label;
}

-(UIImageView *)_createCheckMark
{
    UIImage *checkMark = [UIImage imageNamed:@"checkMark"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:checkMark];
    imageView.hidden = YES;
    return imageView;
}

- (void)setViewDataWithQuizData:(NSDictionary *)quizData choiceNumber:(int)choiceNumber
{
    self.tag = choiceNumber;
    
    NSString *choiceNumberStr = [[NSString alloc] initWithFormat:@"%d", choiceNumber];
    self.choiceNumberLabel.text = choiceNumberStr;
    
    NSArray *choices = quizData[@"choices"];
    NSString *choiceStringStr = [[NSString alloc] initWithFormat:@"A: %@\nB: %@",
                                 choices[choiceNumber-1][0], choices[choiceNumber-1][1]];
    self.choiceStringLabel.text = choiceStringStr;
    [self.choiceStringLabel sizeToFit];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float stringLabelWidth = self.choiceStringLabel.frame.size.width;
    
    self.choiceNumberLabel.frame = CGRectMake(13.0f, 13.0f, 34.0f, 34.0f);
    self.choiceStringLabel.frame = CGRectMake(60.0f, 0, stringLabelWidth, 60.0f);
    self.checkMark.frame = CGRectMake(60.0f+stringLabelWidth+11.0f, 21.0f, 18.0f, 17.0f);
}

- (float)getLabelWidth
{
    float width = self.choiceStringLabel.frame.size.width;
    return width;
}

- (void)resizeLabelWithLabelWidth:(float)width
{
    CGRect rect = self.choiceStringLabel.frame;
    rect.size.width = width;
    self.choiceStringLabel.frame = rect;
}

- (void)respondToTouch
{
    self.choiceStringLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    self.checkMark.hidden = NO;
}

- (void)cancelTheTouch
{
    self.choiceStringLabel.font = [UIFont systemFontOfSize:15.0f];
    self.checkMark.hidden = YES;
}

@end