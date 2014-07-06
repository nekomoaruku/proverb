#import "I3StampViewController.h"
#import "I3StampCardView.h"
#import "I3FooterView.h"

@interface I3StampViewController ()

@property UILabel *titleLabel;
@property UILabel *descriptionLabel;
@property I3StampCardView *stampCardView;
@property I3FooterView *footerView;

@end

@implementation I3StampViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.view.backgroundColor = [UIColor colorWithRed:75.0f/255.0f
                                                    green:188.0f/255.0f
                                                     blue:218.0f/255.0f alpha:1];
        CGRect rect = CGRectZero;
        
        // タイトルの初期化
        self.titleLabel = [[UILabel alloc] initWithFrame:rect];
        self.titleLabel.text = @"名言スタンプ帳";
        self.titleLabel.font = [UIFont boldSystemFontOfSize:24.0f];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self.titleLabel sizeToFit];
        self.titleLabel.center = CGPointMake(self.view.frame.size.width * 0.5,
                                             self.view.frame.size.height * 0.14);
        [self.view addSubview:self.titleLabel];
        
        // 説明文の初期化
        self.descriptionLabel = [[UILabel alloc] initWithFrame:rect];
        self.descriptionLabel.text = @"これまでクイズに答えた名言たちです\n全部集めて名言マスターを目指しましょう";
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
        self.descriptionLabel.font = [UIFont systemFontOfSize:16.0f];
        self.descriptionLabel.textColor = [UIColor whiteColor];
        [self.descriptionLabel sizeToFit];
        self.descriptionLabel.center = CGPointMake(self.view.frame.size.width * 0.5,
                                                   self.view.frame.size.height * 0.25);
        [self.view addSubview:self.descriptionLabel];
        
        // スタンプカードの初期化
        rect = CGRectMake(0, 0, 240, 280);
        CGSize stampSize = CGSizeMake(50, 56);
        self.stampCardView = [[I3StampCardView alloc] initWithFrame:rect
                                                         numberOfStamp:20
                                                        numberOfColumn:4
                                                             stampSize:stampSize
                                                        answerdQuizzes:@[@1, @10, @13, @7, @19]];
        self.stampCardView.center = CGPointMake(self.view.frame.size.width * 0.5,
                                                self.view.frame.size.height * 0.6);
        self.stampCardView.delegate = self;
        [self.view addSubview:self.stampCardView];
        
        // フッターの初期化
        self.footerView = [[I3FooterView alloc] initWithFrame:CGRectZero];
        self.footerView.delegate = self;
        self.footerView.leftButtonTitle = @"戻る";
        [self.footerView setInfoButtonVisibility:false];
        [self.view addSubview:self.footerView];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - stamp view delegate method
- (void)stampCardView:(I3StampCardView *)stampCardView didStampPressed:(int)stampNumber;
{
    NSLog(@"%i", stampNumber);
}

#pragma mark - footer view delegate method
- (void)footerViewLeftButtonTouched:(I3FooterView *)footerView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)footerViewInfoButtonTouched:(I3FooterView *)footerView
{
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