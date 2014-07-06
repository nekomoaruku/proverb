#import "I3TopViewController.h"
#import "I3ProverbQuizViewController.h"
#import "I3ThinkKotobaLogoView.h"
#import "I3LetsThinkLogoView.h"
#import "I3FooterView.h"

// test
#import "I3StampButton.h"
#import "I3StampCardView.h"
#import "I3StampViewController.h"

@interface I3TopViewController ()

@property I3ThinkKotobaLogoView *thinkKotobaLogo;
@property I3LetsThinkLogoView *letsThinkLogo;
@property I3FooterView *footerView;

@end

@implementation I3TopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect rect;
    rect = CGRectMake(0, 0, 200, 100);
    
    self.thinkKotobaLogo = [[I3ThinkKotobaLogoView alloc] initWithFrame:rect];
    [self.thinkKotobaLogo sizeToFit];
    self.thinkKotobaLogo.center = CGPointMake(self.view.frame.size.width * 0.5,
                                              self.view.frame.size.height * 0.16);
    [self.view addSubview:self.thinkKotobaLogo];
    
    self.letsThinkLogo = [[I3LetsThinkLogoView alloc] initWithFrame:rect];
    [self.letsThinkLogo sizeToFit];
    self.letsThinkLogo.center = CGPointMake(self.view.frame.size.width * 0.5,
                                            self.view.frame.size.height * 0.48);
    [self.view addSubview:self.letsThinkLogo];
    
    self.footerView = [[I3FooterView alloc] initWithFrame:CGRectZero];
    self.footerView.delegate = self;
    // infoボタンを押した時に、_pushProverbQuizViewControllerメソッドが呼ばれるように設定
    self.footerView.centerButtonTitle = @"スタンプ帳へ";
    
    self.view.backgroundColor = [UIColor colorWithRed:75.0f/255.0f green:188.0f/255.0f blue:218.0f/255.0f alpha:1];
    [self.view addSubview:self.footerView];
    
}


- (void)footerViewLeftButtonTouched:(I3FooterView *)footerView
{
    NSLog(@"Left Button touched");
}

- (void)footerViewCenterButtonTouched:(I3FooterView *)footerView
{
    I3StampViewController *viewController = [[I3StampViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)footerViewInfoButtonTouched:(I3FooterView *)footerView
{
}

- (void)_pushProverbQuizViewController
{
//    // I3ProverbQuizViewControllerをnavigationControllerに追加して表示する
//    I3ProverbQuizViewController *viewController = [[I3ProverbQuizViewController alloc] init];
//    [self.navigationController pushViewController:viewController animated:YES];
    I3StampViewController *viewController = [[I3StampViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)stampCardView:(I3StampCardView *)stampCardView didStampPressed:(int)stampNumber;
{
    NSLog(@"%i", stampNumber);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
