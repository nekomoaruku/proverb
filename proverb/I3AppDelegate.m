#import "I3AppDelegate.h"
#import "I3ProverbQuizManager.h"
#import "I3ProverbQuiz.h"
#import "I3TopViewController.h"

@interface I3AppDelegate ()

@property UINavigationController *navController;
@property I3TopViewController *topViewController;

@end

@implementation I3AppDelegate

static bool isDevelopMode = true;
static NSString *testQuizId = @"001007";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Override point for customization after application launch.
    self.topViewController = [[I3TopViewController alloc] init];
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.topViewController];
    self.navController.navigationBarHidden = YES;
    
    // DBを開く
    [[I3ProverbQuizManager sharedManager] openDatabase];
    [[I3ProverbQuizManager sharedManager] updateQuizzesWithBlock:^(void){
        if (isDevelopMode && testQuizId) {
            [[I3ProverbQuizManager sharedManager] setTestQuizId:testQuizId];
        }
    }];
    
    // statusbarを白くする
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // windowを表示
    [self.window setRootViewController:self.navController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[I3ProverbQuizManager sharedManager] closeDatabase];
    [[I3ProverbQuizManager sharedManager] updateQuizzesWithBlock:^(void){
        NSLog(@"Update Quiz Done");
    }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[I3ProverbQuizManager sharedManager] openDatabase];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[I3ProverbQuizManager sharedManager] closeDatabase];
}

@end
