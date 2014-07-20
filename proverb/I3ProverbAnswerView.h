#import <UIKit/UIKit.h>
@class I3ProverbQuiz;

@interface I3ProverbAnswerView : UIView

- (id)initWithFrame:(CGRect)frame proverbQuiz:(I3ProverbQuiz *)proverbQuiz;
- (id)initWithFrame:(CGRect)frame proverbQuiz:(I3ProverbQuiz *)proverbQuiz userChoiceIndex:(int)userChoiceIndex;

@end
