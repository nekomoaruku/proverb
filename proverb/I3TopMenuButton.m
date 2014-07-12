#import "I3TopMenuButton.h"

@interface I3TopMenuButton ()

@end

@implementation I3TopMenuButton

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame title:nil iconImage:nil];
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title iconImage:(UIImage *)iconImage
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // ボタンを生成
        self = [UIButton buttonWithType:UIButtonTypeCustom];
        self.frame = frame;
        
        // 画像を設定
        [self setImage:iconImage forState:UIControlStateNormal];
        
        // タイトルを設定
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont systemFontOfSize:21.0f]];
        
        // アイコンとタイトルが綺麗に並ぶように、タイトルをずらす
        self.titleEdgeInsets = UIEdgeInsetsMake(2, 8, 0, 0);
        
    }
    return self;
}

@end
