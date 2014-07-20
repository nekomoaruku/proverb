#import <Foundation/Foundation.h>

@interface I3ProverbQuiz : NSObject

@property NSString *id;
@property NSNumber *sheet;
@property NSNumber *number;
@property NSString *dataJson;
@property NSDictionary *dataDictionary;
@property NSDate *startDate;
@property NSDate *completionDate;
@property bool isTestMode;

- (id)initWithQuizDataJson:(NSDictionary *)quizData;
- (id)initWithQuizDataJson:(NSString *)dataJson startDate:(NSDate *)startDate completionDate:(NSDate *)completionDate;

@end
