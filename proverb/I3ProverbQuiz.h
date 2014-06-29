#import <Foundation/Foundation.h>

@interface I3ProverbQuiz : NSObject

@property NSString *id;
@property NSNumber *sheet;
@property NSNumber *number;
@property NSDictionary *dataDictionary;
@property NSDate *completionDate;

- (id)initWithQuizData:(NSDictionary *)quizData;

@end
