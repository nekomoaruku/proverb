//
//  I3ProverbView.m
//  proverb
//
//  Created by 今井 響 on 2014/07/02.
//
//

#import "I3ProverbView.h"
#import "I3ProverbQuizManager.h"
#import "QuartzCore/QuartzCore.h"

@interface I3ProverbView()

@property UILabel *proverbLabel;

@end


@implementation I3ProverbView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    //各subViewの初期化を呼ぶ
    self.proverbLabel = [self _createProverbLabel];
    [self addSubview:self.proverbLabel];
    
    //proverbQuizManageからデータを受け取ったタイミングで、各subViewに値が設定されるように
    I3ProverbQuizManager *manager = [I3ProverbQuizManager sharedManager];
    [manager getQuizFromServerWithBlock:^(NSDictionary *quizData) {
        [self _setViewDataWithQuizData:quizData];
    }];
    
    
    return self;
}


- (UILabel *)_createProverbLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:18.0f];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = CGRectMake(0, 100, 320, 134);
    return label;
}


- (void)_setViewDataWithQuizData:(NSDictionary *)quizData
{
//    self.proverbLabel.text = quizData[@"quiz"];
    NSArray *choices = quizData[@"choices"];
    NSNumber *rightChoiceIndex = quizData[@"rightChoiceIndex"];
    NSArray *rightChoices = choices[[rightChoiceIndex intValue]];
    
    //正規表現により、%{quiz}を取り出す
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:quizData[@"quiz"]];
    NSString *pattern = @"#\\{quiz\\}";
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSArray *matches = [regexp matchesInString:string.string options:0 range:NSMakeRange(0, string.string.length)];
    
    __block int counter = [rightChoices count] -1;
    [matches enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult *match, NSUInteger idx, BOOL *stop) {
        NSMutableAttributedString *rightChoice = [[NSMutableAttributedString alloc] initWithString:rightChoices[counter]];
        [rightChoice addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, rightChoice.length)];
        [string replaceCharactersInRange:match.range withAttributedString:rightChoice];
        counter--;
        if(counter <= -1) stop:YES;
    }];
    
    self.proverbLabel.attributedText = string;
    [self.proverbLabel sizeToFit];
    CGRect windowSize = [[UIScreen mainScreen] bounds];
    self.proverbLabel.center = CGPointMake(windowSize.size.width / 2, self.proverbLabel.frame.size.height / 2);

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
