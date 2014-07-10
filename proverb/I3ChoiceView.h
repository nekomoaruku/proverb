#import <UIKit/UIKit.h>

@interface I3ChoiceView : UIView{}
- (void)setViewDataWithQuizData:(NSDictionary *)quizData choiceNumber:(int)choiceNumber;
- (float)getLabelWidth;
- (void)resizeLabelWithLabelWidth:(float)width;
- (void)respondToTouch;
- (void)cancelTheTouch;

@end