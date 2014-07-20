#import <UIKit/UIKit.h>

@interface I3FooterView : UIView

@property (nonatomic) NSString *leftButtonTitle;
@property (nonatomic) NSString *centerButtonTitle;
@property (weak) id delegate;

- (void)setInfoButtonVisibility:(bool)visible;
- (void)setCloseButtonVisibility:(bool)visible;

@end

@protocol I3FooterViewDelegate <NSObject>

- (void)footerViewLeftButtonTouched:(I3FooterView *)footerView;
- (void)footerViewCenterButtonTouched:(I3FooterView *)footerView;
- (void)footerViewInfoButtonTouched:(I3FooterView *)footerView;
- (void)footerViewCloseButtonTouched:(I3FooterView *)footerView;

@end