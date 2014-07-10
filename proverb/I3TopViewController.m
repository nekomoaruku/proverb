#import "I3TopViewController.h"
#import "I3ProverbQuizViewController.h"
#import "I3StampViewController.h"
#import "I3TopMenuButton.h"
#import "I3FooterView.h"

@interface I3TopViewController ()

@property UIButton *goTodayQuizButton;
@property UIButton *goStampCardButton;
@property UIImageView *walkerImageView;
@property I3FooterView *footerView;

@end

@implementation I3TopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 今日のクイズボタンを初期化
    UIImage *newIconImage = [UIImage imageNamed:@"newIcon"];
    self.goTodayQuizButton = [[I3TopMenuButton alloc] initWithFrame:CGRectZero
                                                              title:@"今日の名言クイズ"
                                                          iconImage:newIconImage];
    [self.goTodayQuizButton addTarget:self action:@selector(pushProverbViewController:)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goTodayQuizButton];
    
    // 名言スタンプ帳を初期化
    UIImage *logIconImage = [UIImage imageNamed:@"logIcon"];
    self.goStampCardButton = [[I3TopMenuButton alloc] initWithFrame:CGRectZero
                                                              title:@"名言スタンプ帳を見る"
                                                          iconImage:logIconImage];
    [self.goStampCardButton addTarget:self action:@selector(pushStampCardViewConttroller:)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goStampCardButton];
    
    // 歩いている人の画像を初期化
    UIImage *walkerImage = [UIImage imageNamed:@"walker"];
    self.walkerImageView = [[UIImageView alloc] initWithImage:walkerImage];
    [self.walkerImageView sizeToFit];
    [self.view addSubview:self.walkerImageView];
    
    // フッターの初期化
    self.footerView = [[I3FooterView alloc] initWithFrame:CGRectZero];
    self.footerView.delegate = self;
    [self.view addSubview:self.footerView];
    
    self.view.backgroundColor = [UIColor colorWithRed:75.0f/255.0f green:188.0f/255.0f blue:218.0f/255.0f alpha:1];
    
    [self _layoutViews];
}

- (void)_layoutViews
{
    CGRect rect;
    
    // 今日のクイズボタン
    [self.goTodayQuizButton sizeToFit];
    rect = self.goTodayQuizButton.frame;
    // I3TopMenuButton内でsizeToFitをオーバーライドしても呼ばれなかったので、
    // とりあえずここでwidth+10して表示されるようにする
    rect = CGRectMake(34, 184, rect.size.width + 10, rect.size.height);
    self.goTodayQuizButton.frame = rect;
    
    // 名言スタンプ帳
    [self.goStampCardButton sizeToFit];
    rect = self.goStampCardButton.frame;
    rect = CGRectMake(34, 256, rect.size.width + 10, rect.size.height);
    self.goStampCardButton.frame = rect;
    
    // 歩いている人
    self.walkerImageView.center = CGPointMake(self.view.frame.size.width / 2,
                                              468);
    
    // フッター
    // フッターは初期化時にうまく表示されるように処理してくれているので、
    // ここでは特に何もしなくて大丈夫
}

- (void)pushProverbViewController:(id)sender
{
    NSLog(@"Hello Proverb View Controller!");
    I3ProverbQuizViewController *viewController = [[I3ProverbQuizViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)pushStampCardViewConttroller:(id)sender
{
    I3StampViewController *viewController = [[I3StampViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)footerViewLeftButtonTouched:(I3FooterView *)footerView
{
    NSLog(@"Left Button touched");
}

- (void)footerViewInfoButtonTouched:(I3FooterView *)footerView
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
