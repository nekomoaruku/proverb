#import "I3ProverbQuizView.h"

@interface I3ProverbQuizView ()

@property UILabel *dateLabel;
@property UILabel *proverbLabel;
@property UILabel *answerLabel;
@property UITextField *answerTextField;

@property NSDate *quizDate;
@property NSString *quizString;
@property NSString *quizAnswer;

@end

@implementation I3ProverbQuizView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame quizJson:nil];
}

- (id)initWithFrame:(CGRect)frame quizJson:(NSString *)quizJson
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self _parseQuizJSON:quizJson];
    
    return self;
}

- (void)_parseQuizJSON:(NSString *)quizJson
{
    // JSONがnilの場合、各デフォルト値を設定する
    if (!quizJson) {
        self.quizDate = [NSDate date];
        self.quizString = @"#{quiz}。\nテスト用サンプル格言です";
        self.quizAnswer = @"実は";
        return;
    }
    
    NSError *error = nil;
    NSData *jsonData = [quizJson dataUsingEncoding:NSUTF8StringEncoding];
    id object = [NSJSONSerialization JSONObjectWithData:jsonData
                                                options:0
                                                  error:&error];
    
}

- (UILabel *)_createDateLabel
{
    UILabel *label = [[UILabel alloc] init];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY年 MM月dd日"];
    label.text = [formatter stringFromDate:date];
    
    return label;
}

- (UILabel *)_createProverbLabel
{
    UILabel *label = [[UILabel alloc] init];
    return label;
    
}

- (UILabel *)_createAnswerLabel
{
    UILabel *label = [[UILabel alloc] init];
    return label;
}

- (UITextField *)_createAnswerTextField
{
    UITextField *textField = [[UITextField alloc] init];
    return textField
    ;
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
