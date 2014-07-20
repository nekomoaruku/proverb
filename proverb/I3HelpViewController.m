#import "I3HelpViewController.h"
#import "I3FooterView.h"

@interface I3HelpViewController ()

@property UILabel *poweredByLogo;
@property I3FooterView *footerView;

@end

@implementation I3HelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        // Powered by logo
        self.poweredByLogo = [self _createPoweredByLogo];
        [self.view addSubview:self.poweredByLogo];
        
        // Footer View
        self.footerView = [[I3FooterView alloc] initWithFrame:CGRectZero];
        self.footerView.delegate = self;
        [self.footerView setInfoButtonVisibility:false];
        [self.footerView setCloseButtonVisibility:true];
        [self.view addSubview:self.footerView];
        
        self.view.backgroundColor = [UIColor colorWithRed:75.0f/255.0f green:188.0f/255.0f blue:218.0f/255.0f alpha:1];
        
    }
    return self;
}


- (UILabel *)_createPoweredByLogo
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"Powerd by ibeya";
    label.font = [UIFont fontWithName:@"Arial-MT" size:14.0f];
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    CGRect rect = self.view.frame;
    label.center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    return label;
}

- (void)footerViewCloseButtonTouched:(I3FooterView *)footerView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
