#import "I3TopViewController.h"
#import "I3ThinkKotobaLogoView.h"




#import "I3LetsThinkLogoView.h"
#import "I3FooterView.h"

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
    [self.view addSubview:self.footerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
