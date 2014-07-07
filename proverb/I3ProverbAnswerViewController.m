//
//  I3ProverbAnswerViewController.m
//  proverb
//
//  Created by 今井 響 on 2014/06/23.
//
//

#import "I3ProverbAnswerViewController.h"
#import "I3ProverbAnswerView.h"
#import "I3ProverbView.h"

@interface I3ProverbAnswerViewController ()

@property I3ProverbAnswerView* proverbAnswerView;
@property I3ProverbView* proverbView;

@end


@implementation I3ProverbAnswerViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code
        
        //selfのviewの背景色を設定
        self.view.backgroundColor = [UIColor colorWithRed:85/255.0 green:187/255.0 blue:221/255.0 alpha:1.0];
        
        //I3ProverbAnswerViewの追加
        CGRect rect = CGRectMake(0, 0, 320, 568);
        
        self.proverbAnswerView = [[I3ProverbAnswerView alloc]initWithFrame:rect userChoiceIndex:self.userChoiceIndex];
        [self.proverbAnswerView sizeToFit];
        [self.view addSubview:self.proverbAnswerView];
        
        //I3ProverViewの追加
        CGRect proverbRect = CGRectMake(0, 100, 320, 134);
        self.proverbView = [[I3ProverbView alloc] initWithFrame:proverbRect];
        [self.proverbView sizeToFit];
        [self.view addSubview:self.proverbView];

        
        
    }
    return self;
}


- (void)ViewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
