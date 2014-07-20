#import <UIKit/UIKit.h>
@class I3ProverbQuiz;

@interface I3ProverbAnswerViewController : UIViewController

- (id)initWithProverbQuiz:(I3ProverbQuiz *)proverbQuiz;
- (id)initWithProverbQuiz:(I3ProverbQuiz *)proverbQuiz userChoiceIndex:(int)userChoiceIndex;

@end