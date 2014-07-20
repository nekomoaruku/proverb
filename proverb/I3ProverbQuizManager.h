#import <Foundation/Foundation.h>
#import "I3ProverbQuiz.h"

@interface I3ProverbQuizManager : NSObject

+ (I3ProverbQuizManager *)sharedManager;
- (BOOL)openDatabase;
- (BOOL)closeDatabase;
- (void)updateQuizzesWithBlock:(void (^)(void))block;
- (void)getQuizFromServerWithBlock:(void (^)(NSDictionary *quizDictionary))block;

- (I3ProverbQuiz *)getTodayQuiz;
- (I3ProverbQuiz *)getQuizWithQuizId:(NSString *)quizId;
- (void)updateQuizWithId:(NSString *)quizId startDate:(NSDate *)date;
- (void)updateQuizWithId:(NSString *)quizId completionDate:(NSDate *)date;
- (NSArray *)getAnsweredQuizNumbersWithSheet:(int)sheet;
- (void)setTestQuizId:(NSString *)testQuizId;

@end
