#import <Foundation/Foundation.h>
#import "I3ProverbQuiz.h"

@interface I3ProverbQuizManager : NSObject

+ (I3ProverbQuizManager *)sharedManager;
- (BOOL)openDatabase;
- (BOOL)closeDatabase;
- (void)getQuizFromServerWithBlock:(void (^)(NSDictionary *quizDictionary))block;
- (void)_getQuizzesFromServerWithBlock:(void (^)(NSDictionary *quizDictionary))block;
- (void)insertNewProverbQuiz:(I3ProverbQuiz *)proverbQuiz;
- (I3ProverbQuiz *)getUnfinishedQuiz;

@end
