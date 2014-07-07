//
//  I3ProverbAnswerView.m
//  proverb
//
//  Created by 今井 響 on 2014/06/23.
//
//

#import "I3ProverbAnswerView.h"
#import "I3ProverbQuizManager.h"
#import "QuartzCore/QuartzCore.h"
#import "QuartzCore/CALayer.h"

@interface I3ProverbAnswerView()

@property UILabel *resultLabel;
@property UIImageView *commentImageView;
@property UILabel *caseLabel;

@property NSDictionary *proverbData;
@property int userChoiceIndex;

@end

@implementation I3ProverbAnswerView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame userChoiceIndex:0];
}

- (id)initWithFrame:(CGRect)frame userChoiceIndex:(int)userChoiceIndex
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.userChoiceIndex = userChoiceIndex;
    
    //各subViewの初期化を呼ぶ
    self.resultLabel = [self _createResultLabel];
    [self addSubview:self.resultLabel];
    
    self.commentImageView = [self _createCommentImageView];
    [self addSubview:self.commentImageView];
    
    self.caseLabel = [self _createCaseLabel];
    [self addSubview:self.caseLabel];
    
    
    //proverbQuizManageからデータを受け取ったタイミングで、
    //各subViewに値が設定されるようにしておく
    I3ProverbQuizManager *manager = [I3ProverbQuizManager sharedManager];
    [manager getQuizFromServerWithBlock:^(NSDictionary *quizData) {
        [self _setViewDataWithQuizData:quizData];
    }];
    
    return self;
}


















//- (id)initWithFrame:(CGRect)frame quizJson:(NSString *)quizJson
//{
//    self = [super initWithFrame:frame];
//    if (!self) {
//        return nil;
//    }
//    
//    //各subViewの初期化を呼ぶ
//    self.resultLabel = [self _createResultLabel];
//    [self addSubview:self.resultLabel];
//    
//    self.proverbLabel = [self _createProverbLabel];
//    [self addSubview:self.proverbLabel];
//    
//    self.commentImageView = [self _createCommentImageView];
//    [self addSubview:self.commentImageView];
//
//    self.caseLabel = [self _createCaseLabel];
//    [self addSubview:self.caseLabel];
//
//    
//    //proverbQuizManageからデータを受け取ったタイミングで、
//    //各subViewに値が設定されるようにしておく
//    I3ProverbQuizManager *manager = [I3ProverbQuizManager sharedManager];
//    [manager getQuizFromServerWithBlock:^(NSDictionary *quizData) {
//        [self _setViewDataWithQuizData:quizData];
//    }];
//    
//    return self;
//
//}

- (UILabel *)_createResultLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.numberOfLines = 0;
    label.font = [UIFont boldSystemFontOfSize:24.0f];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

/*
- (UILabel *)_createProverbLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:18.0f];
    label.textColor = [UIColor whiteColor];
    return label;
}

*/
 
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
    //[self.resultLabel sizeToFit];
    
    
    //名言の答えラベルの設定
    //quizDataからproverbをとってくる。
    
    //self.proverbLabel.text = quizData[@"proverb"];
    //[self.proverbLabel sizeToFit];
    
    
    //事例用の画像の設定
    NSURL *imageUrl = [NSURL URLWithString:quizData[@"exampleImageUrl"]];
    NSData *data = [NSData dataWithContentsOfURL:imageUrl];
    self.commentImageView.image = [UIImage imageWithData:data];
    
    //解説の本文の設定
    //quizDataからcaseをとってくる。
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
    rect.origin = CGPointMake(0, 20);
    rect.size = CGSizeMake(320, 70);
    rect.size.width = sc.bounds.size.width;
    self.resultLabel.frame = rect;
    
    
    /*  外部でクラスを作ることにする
    rect = self.proverbLabel.frame;
    rect.size = CGSizeMake(sc.bounds.size.width, 134);
    rect.origin = CGPointMake((sc.bounds.size.width - self.proverbLabel.frame.size.width) / 2, 70);
    self.proverbLabel.frame = rect;
     */

    rect = self.commentImageView.frame;
    rect.origin = CGPointMake((sc.bounds.size.width - self.commentImageView.frame.size.width) / 2, 204);
    self.commentImageView.frame = rect;

    rect = self.caseLabel.frame;
    rect.origin = CGPointMake((sc.bounds.size.width - self.caseLabel.frame.size.width) / 2, 324);
    rect.size = CGSizeMake(260, 204);
    self.caseLabel.frame = rect;

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
