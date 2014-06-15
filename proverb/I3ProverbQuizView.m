#import "I3ProverbQuizView.h"
#import "I3ProverbQuizManager.h"

@interface I3ProverbQuizView ()

@property UILabel *proverbLabel;
@property UILabel *choicesLable;
@property UIImageView *exampleImageView;

@property NSDictionary *proverbData;
@property int userSelectedChoiceIndex;

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
    
    // 各subViewの初期化を呼ぶ
    self.proverbLabel = [self _createProverbLabel];
    [self addSubview:self.proverbLabel];
    
    self.choicesLable = [self _createChoicesLable];
    [self addSubview:self.choicesLable];
    
    self.exampleImageView = [self _createExampleImageView];
    [self addSubview:self.exampleImageView];
    
    
    // proverbQuizManageからデータを受け取ったタイミングで、
    // 各subViewに値が設定されるようにしておく
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
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textColor = [UIColor orangeColor];
    return label;
}

- (UILabel *)_createChoicesLable
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14.0f];
    return label;
}

- (UIImageView *)_createExampleImageView
{
    // 画像のサイズは固定、位置は可変という前提で、
    // 固定のサイズについてはinitで設定してしまう。位置には適当に0を入れておく。
    CGRect rect = CGRectMake(0, 0, 250, 250);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    return imageView;
}

- (void)_setViewDataWithQuizData:(NSDictionary *)quizData
{
    // 名言ラベルの設定
    // quizDataからproverbをとってくるだけ。
    self.proverbLabel.text = quizData[@"proverb"];
    [self.proverbLabel sizeToFit];
    
    
    // 選択肢ラベルの設定
    // まず、quizDataからchoicesを取得する。
    // 取得したchoicesをfor文で回して、文字列を作っている。
    // 今回は単純に、改行とカンマ区切りでつなげるている。
    NSMutableString *choicesString = [NSMutableString stringWithString:@""];
    for (NSArray *choice in quizData[@"choices"]) {
        NSString *choiceStr = [choice componentsJoinedByString:@","];
        [choicesString appendString:choiceStr];
        [choicesString appendString:@"\n"];
    }
    // 最後の余分な改行を削除
    [choicesString deleteCharactersInRange:
        NSMakeRange(choicesString.length -2, 1)];
    self.choicesLable.text = choicesString;
    [self.choicesLable sizeToFit];
    
        
    // 事例用の画像の設定
    NSURL *imageUrl = [NSURL URLWithString:quizData[@"exampleImageUrl"]];
    NSData *data = [NSData dataWithContentsOfURL:imageUrl];
    self.exampleImageView.image = [UIImage imageWithData:data];
    
    
    // 値を設定したので、描画の更新を呼び出す。
    // setNeesLayoutを呼ぶと、必要であるかどうかを判断した上で、
    // layoutSubviewsを呼び出してくれる。らしい。
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    // サンプルなので適当な数字を設定している
    // 実際はどんなデータでも適切な位置に表示できるように頑張る必要がある。
    CGRect rect;
    
    rect = self.proverbLabel.frame;
    rect.origin = CGPointMake(20, 20);
    self.proverbLabel.frame = rect;
    
    rect = self.choicesLable.frame;
    rect.origin = CGPointMake(20, 100);
    self.choicesLable.frame = rect;
    
    rect = self.exampleImageView.frame;
    rect.origin = CGPointMake(20, 200);
    self.exampleImageView.frame = rect;
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
