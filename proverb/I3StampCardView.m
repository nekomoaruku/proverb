#import "I3StampCardView.h"
#import "I3StampButton.h"

@interface I3StampCardView ()

@property int numberOfStamp;
@property int numberOfColumn;
@property CGSize stampSize;
@property NSArray *answerdQuizzes;

@end

@implementation I3StampCardView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame
                   numberOfStamp:20
                  numberOfColumn:4
                     stampSize:CGSizeMake(50, 55)
                answerdQuizzes:[NSArray array]];
}

- (id)initWithFrame:(CGRect)frame numberOfStamp:(int)numberOfStamp numberOfColumn:(int)numberOfColumn
          stampSize:(CGSize)stampSize answerdQuizzes:(NSArray *)answerdQuizzes
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    // インスタンス変数に設定
    self.numberOfStamp = numberOfStamp;
    self.numberOfColumn = numberOfColumn;
    self.stampSize = stampSize;
    self.answerdQuizzes = answerdQuizzes;
    
    for (int stampNumber = 1; stampNumber <= numberOfStamp; stampNumber++) {
        // 回答済みの問題かどうか判断
        bool answerd = [answerdQuizzes containsObject:[NSNumber numberWithInt:stampNumber]];
        I3StampButton *button = [self _createStampButtonWithStampNumber:stampNumber answerState:answerd];
        [self addSubview:button];
    }
    return self;
}

- (I3StampButton *)_createStampButtonWithStampNumber:(int)stampNumber answerState:(bool)answerd
{
    // ボタンのインスタンスを生成
    CGRect buttonFrame = [self _stampFrameWithStampNumber:stampNumber];
    I3StampButton *button = [[I3StampButton alloc] initWithFrame:buttonFrame
                                                          number:stampNumber
                                                     answerState:answerd];
    // ボタンにタグと、アクションを設定
    // 各ボタンがタッチされた時、delegateに押されたボタンNoを伝える
    button.tag = stampNumber;
    [button addTarget:self action:@selector(_stampButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (CGRect)_stampFrameWithStampNumber:(int)stampNumber
{
    
    // スタンプの縦横
    int stampWidth = self.stampSize.width;
    int stampHeight = self.stampSize.height;
    
    // 行と列の数
    int numberOfColumn = self.numberOfColumn;
    int numberOfRow = ceil((double)self.numberOfStamp / numberOfColumn);
    
    // スタンプ間のマージン
    int marginWidth = (self.frame.size.width - (stampWidth * numberOfColumn)) / (numberOfColumn - 1);
    int marginHeight = (self.frame.size.height - (stampHeight * numberOfRow)) / (numberOfRow - 1);
    
    // スタンプの座標を計算
    int stampIndex = stampNumber - 1;
    int originX = (stampIndex % numberOfColumn) * (stampWidth + marginWidth);
    int originY = floor((double)stampIndex / numberOfColumn) * (stampHeight + marginHeight);
    
    return CGRectMake(originX, originY, stampWidth, stampHeight);
}

- (void)_stampButtonPressed:(I3StampButton *)sender
{
    [self.delegate stampCardView:self didStampPressed:sender.tag];
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
