#import "I3ProverbAnswerView.h"
#import "I3ProverbQuizManager.h"
#import "I3ProverbQuiz.h"
#import "I3NumberBalloonView.h"

@interface I3ProverbAnswerView()

@property UILabel *resultLabel;
@property I3NumberBalloonView *numberBalloonView;
@property UIImageView *commentImageView;
@property UILabel *caseLabel;

@property NSDictionary *proverbData;
@property int userChoiceIndex;

@end

@implementation I3ProverbAnswerView

- (id)initWithFrame:(CGRect)frame proverbQuiz:(I3ProverbQuiz *)proverbQuiz
{
    return [self initWithFrame:frame proverbQuiz:proverbQuiz userChoiceIndex:-1];
}

- (id)initWithFrame:(CGRect)frame proverbQuiz:(I3ProverbQuiz *)proverbQuiz userChoiceIndex:(int)userChoiceIndex
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.userChoiceIndex = userChoiceIndex;
    
    //各subViewの初期化を呼ぶ
    self.resultLabel = [self _createResultLabel];
    if (userChoiceIndex != -1) [self addSubview:self.resultLabel];
    
    self.numberBalloonView = [self _createNumberBalloonView];
    if (userChoiceIndex == -1) [self addSubview:self.numberBalloonView];
    
    self.commentImageView = [self _createCommentImageView];
    [self addSubview:self.commentImageView];
    
    self.caseLabel = [self _createCaseLabel];
    [self addSubview:self.caseLabel];
    
//    I3ProverbQuiz *todayQuiz = [[I3ProverbQuizManager sharedManager] getTodayQuiz];
    [self _setViewDataWithQuizData:proverbQuiz.dataDictionary];
    
    return self;
}

- (UILabel *)_createResultLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize:24.0f];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}


- (I3NumberBalloonView *)_createNumberBalloonView
{
    CGRect screen = [[UIScreen mainScreen] applicationFrame];
    I3NumberBalloonView *balloonView = [[I3NumberBalloonView alloc] initWithFrame:CGRectZero];
    balloonView.center = CGPointMake(screen.size.width*0.5f, screen.size.height*0.12f);
    return balloonView;
}

- (UIImageView *)_createCommentImageView
{
    //画像のサイズは固定、位置は可変という前提で、
    //固定のサイズについてはinitで設定してしまう。位置には適当に0を入れておく。
    CGRect rect = CGRectMake(0, 0, 160, 100);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.clipsToBounds = true;

    //枠線をつける
    CALayer *layer =[imageView layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:2.f];
    [layer setBorderColor:[[UIColor whiteColor] CGColor]];
    layer.cornerRadius = 5;
    return imageView;
}

- (UILabel *)_createCaseLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textColor = [UIColor whiteColor];
    return label;
}


- (void)_setViewDataWithQuizData:(NSDictionary *)quizData
{
    //正否ラベルの設定
    //quizDataからrightChoiceIndexを取り、
    //ユーザーの回答と照らし合わせて正否を入れる
    NSNumber *rightChoiceIndex = quizData[@"rightChoiceIndex"];
    if (self.userChoiceIndex == [rightChoiceIndex intValue]){
        self.resultLabel.text = @"正解！";
    }else {
        self.resultLabel.text = @"残念！正解は…";
    }
    
    //風船数字のやつ
    [self.numberBalloonView setViewDataWithQuizData:quizData];
    
    //事例用の画像の設定
    NSURL *imageUrl = [NSURL URLWithString:quizData[@"exampleImageUrl"]];
    NSData *data = [NSData dataWithContentsOfURL:imageUrl];
    self.commentImageView.image = [UIImage imageWithData:data];
    
    //解説の本文の設定
    //quizDataからexampleをとってくる。
    self.caseLabel.text = quizData[@"example"];
    [self.caseLabel sizeToFit];
    
    //描画の更新。
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    //各要素の位置を綺麗に表示できるように頑張る
    //ひとまず適当
    CGRect rect;
    UIScreen *sc = [UIScreen mainScreen];
    
    rect = self.resultLabel.frame;
    rect.origin = CGPointMake(0, 36);
    rect.size = CGSizeMake(320, 70);
    rect.size.width = sc.bounds.size.width;
    self.resultLabel.frame = rect;
    
    rect = self.commentImageView.frame;
    rect.origin = CGPointMake((sc.bounds.size.width - self.commentImageView.frame.size.width) / 2, 214);
    self.commentImageView.frame = rect;

    rect = self.caseLabel.frame;
//    rect.origin = CGPointMake((sc.bounds.size.width - self.caseLabel.frame.size.width) / 2, 324);
//    rect.size = CGSizeMake(260, 204);
    self.caseLabel.frame = CGRectMake(30, 312, 260, 204);

}

@end
