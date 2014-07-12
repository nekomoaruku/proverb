#import <UIKit/UIKit.h>

@interface I3TopMenuButton : UIButton;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title iconImage:(UIImage *)iconImage;
- (void)sizeToFit;

@end
