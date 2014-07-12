#import "I3ProverbQuizView.h"

@interface I3ProverbQuizView ()

@property UILabel *proverbLabel;

@end


@implementation I3ProverbQuizView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.proverbLabel = [self _createProverbLabel];
        [self addSubview:self.proverbLabel];
    }
    return self;
}

- (UILabel *)_createProverbLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:20.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    return label;
}

- (void)setViewDataWithQuizData:(NSDictionary *)quizData
{
    NSString *proverbStr = [[NSString alloc] initWithString:quizData[@"quiz"]];
    proverbStr = [proverbStr stringByReplacingOccurrencesOfString:@"#{blank0}"
                                                       withString:@" [ A ] "];
    NSRange result = [proverbStr rangeOfString:@"#{blank1}"];
    if(!(result.location == NSNotFound)){
        proverbStr = [proverbStr stringByReplacingOccurrencesOfString:@"#{blank1}"
                                                       withString:@" [ B ] "];
        NSRange result = [proverbStr rangeOfString:@"#{blank2}"];
        if(!(result.location == NSNotFound)){
            proverbStr = [proverbStr stringByReplacingOccurrencesOfString:@"#{blank2}"
                                                           withString:@" [ C ] "];
            NSRange result = [proverbStr rangeOfString:@"#{blank3}"];
            if(!(result.location == NSNotFound)){
                proverbStr = [proverbStr stringByReplacingOccurrencesOfString:@"#{blank3}"
                                                                   withString:@" [ D ] "];
                NSRange result = [proverbStr rangeOfString:@"#{blank4}"];
                if(!(result.location == NSNotFound)){
                    proverbStr = [proverbStr stringByReplacingOccurrencesOfString:@"#{blank4}"
                                                                   withString:@" [ E ] "];
                }
            }
        }
    };
    self.proverbLabel.text = proverbStr;
    
    [self.proverbLabel sizeToFit];
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.proverbLabel.center = CGPointMake(self.frame.size.width*0.5f, self.frame.size.height*0.5f);
    
}

@end
