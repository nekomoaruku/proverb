#import "I3ProverbAnswerViewController.h"
#import "I3ProverbAnswerView.h"
#import "I3ProverbView.h"
#import "I3FooterView.h"

#import "I3StampViewController.h"

@interface I3ProverbAnswerViewController ()

@property I3ProverbAnswerView* proverbAnswerView;
@property I3ProverbView* proverbView;
@property I3FooterView *footerView;

@end


@implementation I3ProverbAnswerViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithUserChoiceIndex:0];
}

- (id)initWithUserChoiceIndex:(int)userChoiceIndex
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
        //selfのviewの背景色を設定
        self.view.backgroundColor = [UIColor colorWithRed:75.0f/255.0f green:188.0f/255.0f blue:218.0f/255.0f alpha:1];
        
        //I3ProverbAnswerViewの追加
        CGRect rect = CGRectMake(0, 0, 320, 568);
        
        self.proverbAnswerView = [[I3ProverbAnswerView alloc]initWithFrame:rect userChoiceIndex:userChoiceIndex];
        [self.proverbAnswerView sizeToFit];
        [self.view addSubview:self.proverbAnswerView];
        
        //I3ProverViewの追加
        CGRect proverbRect = CGRectMake(0, 120, 320, 134);
        self.proverbView = [[I3ProverbView alloc] initWithFrame:proverbRect];
        [self.proverbView sizeToFit];
        [self.view addSubview:self.proverbView];
        
        //footerViewの追加
        self.footerView = [[I3FooterView alloc] initWithFrame:CGRectZero];
        self.footerView.delegate = self;
        self.footerView.centerButtonTitle = @"スタンプ帳へ";
        [self.footerView setInfoButtonVisibility:false];
        [self.view addSubview:self.footerView];
        
    }
    return self;
}

- (void)ViewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)footerViewCenterButtonTouched:(I3FooterView *)footerView
{
    I3StampViewController *viewController = [[I3StampViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
