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
static const NSString *SERVER_HOST = @"localhost:3000";
static const NSString *DB_FILE = @"I3Proverb.db";
static NSString *latestQuizId;

+ (I3ProverbQuizManager *)sharedManager
{
    // Singleton
    if (!_sharedInstance) {
        _sharedInstance = [[I3ProverbQuizManager alloc] init];
        latestQuizId = [[NSUserDefaults standardUserDefaults] stringForKey:@"LATEST_QUIZ_ID"];
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
            "startDate REAL, completionDate REAL, isTestMode INTEGER NOT NULL)";
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
                        I3ProverbQuiz *quiz = [[I3ProverbQuiz alloc] initWithQuizDataJson:quizData[@"dataJson"]];
                        [self insertOrReplaceProverbQuiz:quiz];
                    }
                    
                    block();
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    // エラーの場合はエラーの内容をコンソールに出力する
                    NSLog(@"Error: %@", error);
                }];
}

- (void)insertOrReplaceProverbQuiz:(I3ProverbQuiz *)proverbQuiz
{
    NSString *selectProverbQuizSql = @"SELECT * FROM proverb_quiz WHERE id = ?";
    FMResultSet *rs = [self.db executeQuery:selectProverbQuizSql, proverbQuiz.id];
    if ([rs next]) {
        NSString *updateProverQuizSql = @"UPDATE proverb_quiz SET dataJson = ?, isTestMode = ? WHERE id = ?";
        [self.db executeUpdate:updateProverQuizSql, proverbQuiz.dataJson, [NSNumber numberWithBool:proverbQuiz.isTestMode], proverbQuiz.id];
        NSLog(@"update!");
    } else {
        NSString *insertProverbQuizSql = @"INSERT INTO proverb_quiz values (?, ?, ?, ?, ?, ?, ?)";
        [self.db executeUpdate:insertProverbQuizSql, proverbQuiz.id, proverbQuiz.sheet, proverbQuiz.number, proverbQuiz.dataJson, proverbQuiz.startDate, proverbQuiz.completionDate, [NSNumber numberWithBool:proverbQuiz.isTestMode]];
        NSLog(@"insert!");
    }
}

- (I3ProverbQuiz *)getTodayQuiz
{
    // latestQuizIdがnilなら、ランダム取得して返す
    I3ProverbQuiz *latestQuiz;
    if (!latestQuizId) {
        latestQuiz = [self getUnCompletedRandomQuiz];
    }
    
    // latestQuizのstartDateが本日かどうか確認
    latestQuiz = [self getQuizWithQuizId:latestQuizId];
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *todayString = [formatter stringFromDate:now];
    NSDate *today = [formatter dateFromString:todayString];
    
    if (![latestQuiz.startDate isEqualToDate:today]) {
        // 本日ではなかった場合は現在のlatestQuizのstartDateをnullにして、
        // 新しいlatestQuizをランダムに取得する
        [self clearQuizStartDateWithQuizId:latestQuiz.id];
        latestQuiz = [self getUnCompletedRandomQuiz];
    } else {
        // 本日だった場合は、回答済みか判断
        // TODO: 回答済みだった場合と、未回答の場合で場合分け
    }
    
    // latestQuizIdを更新
    [[NSUserDefaults standardUserDefaults] setObject:latestQuiz.id forKey:@"LATEST_QUIZ_ID"];
    latestQuizId = latestQuiz.id;
    
    // latestQuiz
    return latestQuiz;
}

- (I3ProverbQuiz *)getUnCompletedRandomQuiz
{
    NSString *selectUnfinishedQuizzesSql = @"SELECT * FROM proverb_quiz WHERE completionDate IS NULL AND isTestMode = 0";
    FMResultSet *rs = [self.db executeQuery:selectUnfinishedQuizzesSql];
    NSMutableArray *quizzes = [NSMutableArray array];
    while ([rs next]) {
        I3ProverbQuiz *quiz = [[I3ProverbQuiz alloc] initWithQuizDataJson:[rs stringForColumn:@"dataJson"] startDate:[rs dateForColumn:@"startDate"] completionDate:[rs dateForColumn:@"completionDate"]];
        [quizzes addObject:quiz];
    }
    
    if (quizzes.count == 0) {
        return nil;
    }
    
    int randomIndex = arc4random() % quizzes.count;
    I3ProverbQuiz *todayQuiz = [quizzes objectAtIndex:randomIndex];
    
    // 今日の日付で00:00のNSDateをstartDateに登録する
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *todayString = [formatter stringFromDate:now];
    NSDate *today = [formatter dateFromString:todayString];
    
    [self updateQuizWithId:todayQuiz.id startDate:today];
    return [quizzes objectAtIndex:randomIndex];
}

- (I3ProverbQuiz *)getQuizWithQuizId:(NSString *)quizId;
{
    NSString *selectQuizSql = @"SELECT * FROM proverb_quiz WHERE id = ?";
    FMResultSet *rs = [self.db executeQuery:selectQuizSql, quizId];
    I3ProverbQuiz *quiz;
    if ([rs next]) {
        quiz = [[I3ProverbQuiz alloc] initWithQuizDataJson:[rs stringForColumn:@"dataJson"] startDate:[rs dateForColumn:@"startDate"] completionDate:[rs dateForColumn:@"completionDate"]];
    }
    return quiz;
}

- (void)updateQuizWithId:(NSString *)quizId startDate:(NSDate *)date
{
    NSString *updateSql = @"UPDATE proverb_quiz SET startDate = ? WHERE id = ?";
    [self.db executeUpdate:updateSql, date, quizId];
}

- (void)updateQuizWithId:(NSString *)quizId completionDate:(NSDate *)date
{
    NSString *updateSql = @"UPDATE proverb_quiz SET completionDate = ? WHERE id = ?";
    [self.db executeUpdate:updateSql, date, quizId];
}

- (void)clearQuizStartDateWithQuizId:(NSString *)quizId
{
    NSString *clearQuizSql = @"UPDATE proverb_quiz SET startDate = NULL WHERE id = ?";
    [self.db executeQuery:clearQuizSql, quizId];
}

- (NSArray *)getAnsweredQuizNumbersWithSheet:(int)sheet
{
    NSString *selectAnsweredQuizzesSql = @"SELECT * FROM proverb_quiz WHERE completionDate IS NOT NULL AND isTestMode = 0 AND sheet = ?";
    FMResultSet *rs = [self.db executeQuery:selectAnsweredQuizzesSql, [NSNumber numberWithInt:sheet]];
    NSMutableArray *answerdQuizNumbers = [NSMutableArray array];
    while ([rs next]) {
        NSNumber *quizNumber = [NSNumber numberWithInt:[rs intForColumn:@"number"]];
        [answerdQuizNumbers addObject:quizNumber];
    }
    return answerdQuizNumbers;
}

- (void)setTestQuizId:(NSString *)testQuizId
{
    [[NSUserDefaults standardUserDefaults] setObject:testQuizId forKey:@"LATEST_QUIZ_ID"];
    latestQuizId = testQuizId;
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *todayString = [formatter stringFromDate:now];
    NSDate *today = [formatter dateFromString:todayString];
    [self updateQuizWithId:testQuizId startDate:today];
}

@end