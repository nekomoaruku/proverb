#import <Foundation/Foundation.h>

@interface I3ProverbQuizManager : NSObject

+ (I3ProverbQuizManager *)sharedManager;
- (void)getQuizFromServerWithBlock:(void (^)(NSDictionary *quizDictionary))block;


@end
