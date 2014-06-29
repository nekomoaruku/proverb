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
        @"CREATE TABLE proverb_quiz (id TEXT NOT NULL, sheet INTEGER NOT NULL, "
            "number INTEGER NOT NULL, dataJson TEXT NOT NULL, completionDate INTEGER)";
    [self.db open];
    [self.db executeUpdate:createProverbQuizTable];
}

- (void)_getQuizzesFromServerWithBlock:(void (^)(NSDictionary *quizDictionary))block
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
                        I3ProverbQuiz *quiz = [[I3ProverbQuiz alloc] initWithQuizData:quizData];
                        [self insertNewProverbQuiz:quiz];
                    }
                    
                    block((NSDictionary *)responseObject);
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    // エラーの場合はエラーの内容をコンソールに出力する
                    NSLog(@"Error: %@", error);
                }];
}

- (void)insertNewProverbQuiz:(I3ProverbQuiz *)proverbQuiz;
{
    NSString *insertProverbQuizSql =
        @"INSERT INTO proverb_quiz values (?, ?, ?, ?, ?)";
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:proverbQuiz.dataDictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *dataJson = [[NSString alloc] initWithData:jsonData
                                               encoding:NSUTF8StringEncoding];
    [self.db executeUpdate:insertProverbQuizSql, proverbQuiz.id, proverbQuiz.sheet,
        proverbQuiz.number, dataJson, proverbQuiz.completionDate];
}

- (I3ProverbQuiz *)getUnfinishedQuiz
{
    NSString *selectUnfinishedQuizzesSql =
        @"SELECT * FROM proverb_quiz WHERE completionDate IS NULL";
    FMResultSet *rs = [self.db executeQuery:selectUnfinishedQuizzesSql];
    NSMutableArray *quizzes = [NSMutableArray array];
    while ([rs next]) {
        I3ProverbQuiz *quiz = [[I3ProverbQuiz alloc] init];
        quiz.id = [rs stringForColumnIndex:0];
        quiz.sheet = [NSNumber numberWithInt:[rs intForColumnIndex:1]];
        quiz.number = [NSNumber numberWithInt:[rs intForColumnIndex:2]];
        NSData *jsonData = [[rs stringForColumnIndex:3] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:&error];
        quiz.dataDictionary = dataDictionary;
        quiz.completionDate = nil;
    
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