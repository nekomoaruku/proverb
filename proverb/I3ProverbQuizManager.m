#import "I3ProverbQuizManager.h"
#import "FMDatabase.h"
#import "AFHTTPSessionManager.h"
#import "I3ProverbQuiz.h"

@interface I3ProverbQuizManager ()

@property AFHTTPSessionManager *afManager;
@property FMDatabase *db;

@end

@implementation I3ProverbQuizManager

static I3ProverbQuizManager *_sharedInstance;
static NSString* const SERVER_HOST = @"localhost:3000";
static NSString* const DB_FILE = @"I3Proverb.db";

+ (I3ProverbQuizManager *)sharedManager
{
    // Singleton
    if (!_sharedInstance) {
        _sharedInstance = [[I3ProverbQuizManager alloc] init];
    }
    return _sharedInstance;
}

- (BOOL)openDatabase
{
    NSString *dbPath = nil;
    NSArray *documentsPath = NSSearchPathForDirectoriesInDomains
        (NSDocumentDirectory, NSUserDomainMask, YES);
    
    if ([documentsPath count] >= 1) {
        dbPath = [documentsPath objectAtIndex:0];
        dbPath = [dbPath stringByAppendingPathComponent:DB_FILE];
        NSLog(@"DB file path : %@", dbPath);
    } else {
        NSLog(@"search Document path error. database file open error.");
        return NO;
    }
    
    self.db = [FMDatabase databaseWithPath:dbPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPath]) {
        [self _createDatabaseWithDbPath:dbPath];
    } else {
        [self.db open];
    }
    return YES;
}

- (BOOL)closeDatabase
{
    [self.db close];
    return YES;
}

- (void)_createDatabaseWithDbPath:(NSString *)dbPath
{
    NSString *createProverbQuizTable =
        @"CREATE TABLE proverb_quiz (id TEXT PRIMARY KEY, sheet INTEGER NOT NULL, "
            "number INTEGER NOT NULL, dataJson TEXT NOT NULL, "
            "startDate REAL, completionDate REAL)";
    [self.db open];
    [self.db executeUpdate:createProverbQuizTable];
}

- (void)updateQuizzesWithBlock:(void (^)(void))block
{
    // リクエスト用のAPIを作成
    NSString *requestUrl =
        [NSString stringWithFormat:@"http://%@/proverbs", SERVER_HOST];
    
    // APIサーバにリクエストを投げる
    self.afManager = [AFHTTPSessionManager manager];
    [self.afManager GET:requestUrl
             parameters:nil
                success:^(NSURLSessionDataTask *task, id responseObject) {
                    
                    // 通信に成功した場合の処理
                    for (NSDictionary *quizData in responseObject) {
                        I3ProverbQuiz *quiz = [[I3ProverbQuiz alloc] initWithQuizDataJson:quizData[@
                                               "dataJson"]];
                        [self insertOrReplaceProverbQuiz:quiz];
                    }
                    
                    block();
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    // エラーの場合はエラーの内容をコンソールに出力する
                    NSLog(@"Error: %@", error);
                }];
}

- (void)insertOrReplaceProverbQuiz:(I3ProverbQuiz *)proverbQuiz;
{
    NSString *insertProverbQuizSql =
        @"INSERT OR REPLACE INTO proverb_quiz values (?, ?, ?, ?, ?, ?)";
    [self.db executeUpdate:insertProverbQuizSql, proverbQuiz.id, proverbQuiz.sheet,
        proverbQuiz.number, proverbQuiz.dataJson, proverbQuiz.startDate, proverbQuiz.completionDate];
}

- (I3ProverbQuiz *)getTodayQuiz
{
    NSString *selectUnfinishedQuizzesSql =
        @"SELECT * FROM proverb_quiz WHERE completionDate IS NULL";
    FMResultSet *rs = [self.db executeQuery:selectUnfinishedQuizzesSql];
    NSMutableArray *quizzes = [NSMutableArray array];
    while ([rs next]) {
        I3ProverbQuiz *quiz = [[I3ProverbQuiz alloc] initWithQuizDataJson:[rs stringForColumn:@"dataJson"] startDate:[rs dateForColumn:@"startDate"] completionDate:[rs dateForColumn:@"completionDate"]];
        [quizzes addObject:quiz];
    }
    
    int randomIndex = arc4random() % quizzes.count;
    return [quizzes objectAtIndex:randomIndex];
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