#import <UIKit/UIKit.h>

@interface I3StampCardView : UIView

@property (weak) id delegate;

- (id)initWithFrame:(CGRect)frame numberOfStamp:(int)numberOfStamp numberOfColumn:(int)numberOfColumn
          stampSize:(CGSize)stampSize answerdQuizzes:(NSArray *)answerdQuizzes;
@end

@protocol I3StampCardViewDelegate <NSObject>

- (void)stampCardView:(I3StampCardView *)stampCardView didStampPressed:(int)stampNumber;

@end