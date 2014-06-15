#import "I3ProverbQuizManager.h"
#import "AFHTTPSessionManager.h"

@interface I3ProverbQuizManager ()

@property AFHTTPSessionManager *afManager;

@end

@implementation I3ProverbQuizManager

static I3ProverbQuizManager *_sharedInstance;

+ (I3ProverbQuizManager *)sharedManager
{
    // Singleton.
    if (!_sharedInstance) {
        _sharedInstance = [[I3ProverbQuizManager alloc] init];
    }
    return _sharedInstance;
}

- (void)getQuizFromServerWithBlock:(void (^)(NSDictionary *quizDictionary))block
{
    // APIサーバにリクエストを投げる
    self.afManager = [AFHTTPSessionManager manager];
    [self.afManager GET:@"http://localhost:3000/proverbs/0"
             parameters:nil
                success:^(NSURLSessionDataTask *task, id responseObject) {
                    // 通信に成功した場合の処理
                    block((NSDictionary *)responseObject);
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    // エラーの場合はエラーの内容をコンソールに出力する
                    NSLog(@"Error: %@", error);
                }];
}

@end
