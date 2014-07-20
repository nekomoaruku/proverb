#import "I3ProverbQuizViewController.h"
#import "I3ProverbQuizManager.h"
#import "I3ProverbQuiz.h"
#import "I3ProverbAnswerViewController.h"
#import "I3NumberBalloonView.h"
#import "I3ProverbQuizView.h"
#import "I3ChoiceView.h"
#import "I3FooterView.h"

@interface I3ProverbQuizViewController ()

@property I3NumberBalloonView *numberBalloonView;
@property I3ProverbQuizView *proverbQuizView;
@property I3ChoiceView *choiceOneView;
@property I3ChoiceView *choiceTwoView;
@property I3ChoiceView *choiceThreeView;
@property I3ChoiceView *choiceFourView;
@property I3FooterView *footerView;

@property I3ProverbQuiz *proverbQuiz;
@property int userChoiceIndex;

@end

@implementation I3ProverbQuizViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.userInteractionEnabled = YES;

        self.view.backgroundColor = [UIColor colorWithRed:75.0f/255.0f green:188.0f/255.0f blue:218.0f/255.0f alpha:1];

        CGRect screen = [[UIScreen mainScreen] applicationFrame];
        
        self.numberBalloonView = [[I3NumberBalloonView alloc] initWithFrame:CGRectZero];
        self.numberBalloonView.center = CGPointMake(screen.size.width*0.5f, screen.size.height*0.12f);
        self.numberBalloonView.hidden = YES;
        [self.view addSubview:self.numberBalloonView];
        
        
        CGRect rect = CGRectMake(0, screen.size.height*0.062+41.0f,
                                 screen.size.width, screen.size.height*0.338-41.0f);
        self.proverbQuizView = [[I3ProverbQuizView alloc] initWithFrame:rect];
        [self.view addSubview:self.proverbQuizView];
        
        self.choiceOneView = [[I3ChoiceView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:self.choiceOneView];
        self.choiceOneView.hidden = YES;
        
        self.choiceTwoView = [[I3ChoiceView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:self.choiceTwoView];
        self.choiceTwoView.hidden = YES;
        
        self.choiceThreeView = [[I3ChoiceView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:self.choiceThreeView];
        self.choiceThreeView.hidden = YES;
        
        self.choiceFourView = [[I3ChoiceView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:self.choiceFourView];
        self.choiceFourView.hidden = YES;
        
        self.footerView = [[I3FooterView alloc] initWithFrame:CGRectZero];
        self.footerView.delegate = self;
        self.footerView.leftButtonTitle = @"＜ 戻る";
        [self.footerView setInfoButtonVisibility:false];
        [self.view addSubview:self.footerView];
        
        I3ProverbQuiz *quiz = [[I3ProverbQuizManager sharedManager] getTodayQuiz];
        if (!quiz) {
            [self _showNoQuizAlertView];
        } else {
            self.proverbQuiz = quiz;
            [self.numberBalloonView setViewDataWithQuizData:quiz.dataDictionary];
            [self.proverbQuizView setViewDataWithQuizData:quiz.dataDictionary];
            [self.choiceOneView setViewDataWithQuizData:quiz.dataDictionary choiceNumber:1];
            [self.choiceTwoView setViewDataWithQuizData:quiz.dataDictionary choiceNumber:2];
            [self.choiceThreeView setViewDataWithQuizData:quiz.dataDictionary choiceNumber:3];
            [self.choiceFourView setViewDataWithQuizData:quiz.dataDictionary choiceNumber:4];

            self.numberBalloonView.hidden = NO;
            self.choiceOneView.hidden = NO;
            self.choiceTwoView.hidden = NO;
            self.choiceThreeView.hidden = NO;
            self.choiceFourView.hidden = NO;
            
            [self _resizeChoiceViews];
        }
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)_resizeChoiceViews
{
    float width1 = [self.choiceOneView getLabelWidth];
    float width2 = [self.choiceTwoView getLabelWidth];
    float width3 = [self.choiceThreeView getLabelWidth];
    float width4 = [self.choiceFourView getLabelWidth];
    
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:width1],
                      [NSNumber numberWithFloat:width2],
                      [NSNumber numberWithFloat:width3],
                      [NSNumber numberWithFloat:width4], nil];
    
    float maxLabelWidth = [[array valueForKeyPath:@"@max.self"] floatValue] + 10.0f;
    
    [self.choiceOneView resizeLabelWithLabelWidth:maxLabelWidth];
    [self.choiceTwoView resizeLabelWithLabelWidth:maxLabelWidth];
    [self.choiceThreeView resizeLabelWithLabelWidth:maxLabelWidth];
    [self.choiceFourView resizeLabelWithLabelWidth:maxLabelWidth];
    
    float viewWidth = maxLabelWidth + 100.0f;
    float viewHeight = 60.0f;
    
    CGRect screen = [[UIScreen mainScreen] applicationFrame];
    float viewX = (screen.size.width-viewWidth)*0.5f;
    
    self.choiceOneView.frame = CGRectMake(viewX,
                                          screen.size.height*0.400,
                                          viewWidth,
                                          viewHeight);
    self.choiceTwoView.frame = CGRectMake(viewX,
                                          screen.size.height*0.525,
                                          viewWidth,
                                          viewHeight);
    self.choiceThreeView.frame = CGRectMake(viewX,
                                            screen.size.height*0.650,
                                            viewWidth,
                                            viewHeight);
    self.choiceFourView.frame = CGRectMake(viewX,
                                           screen.size.height*0.775,
                                           viewWidth,
                                           viewHeight);
}

- (void)_showNoQuizAlertView
{
    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"クイズがありません！"
                                                      message:@"ごめんなさい！クイズ切れです。\n中の人達が鋭意作成中です。よろしくお願い致します！"
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    switch (touch.view.tag) {
        case 1:
            [self.choiceOneView respondToTouch];
            [self.choiceTwoView cancelTheTouch];
            [self.choiceThreeView cancelTheTouch];
            [self.choiceFourView cancelTheTouch];
            self.footerView.centerButtonTitle = @"決定";
            break;
            
        case 2:
            [self.choiceOneView cancelTheTouch];
            [self.choiceTwoView respondToTouch];
            [self.choiceThreeView cancelTheTouch];
            [self.choiceFourView cancelTheTouch];
            self.footerView.centerButtonTitle = @"決定";
            break;
            
        case 3:
            [self.choiceOneView cancelTheTouch];
            [self.choiceTwoView cancelTheTouch];
            [self.choiceThreeView respondToTouch];
            [self.choiceFourView cancelTheTouch];
            self.footerView.centerButtonTitle = @"決定";
            break;
            
        case 4:
            [self.choiceOneView cancelTheTouch];
            [self.choiceTwoView cancelTheTouch];
            [self.choiceThreeView cancelTheTouch];
            [self.choiceFourView respondToTouch];
            self.footerView.centerButtonTitle = @"決定";
            break;
    }
    self.userChoiceIndex = touch.view.tag - 1;
}

- (void)footerViewLeftButtonTouched:(I3FooterView *)footerView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)footerViewCenterButtonTouched:(I3FooterView *)footerView
{
    I3ProverbAnswerViewController *viewController =
    [[I3ProverbAnswerViewController alloc] initWithProverbQuiz:self.proverbQuiz userChoiceIndex:self.userChoiceIndex];
    [[I3ProverbQuizManager sharedManager] updateQuizWithId:self.proverbQuiz.id completionDate:[NSDate date]];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end