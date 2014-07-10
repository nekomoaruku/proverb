#import "I3ProverbQuiz.h"

@implementation I3ProverbQuiz

- (id)init
{
    return [self initWithQuizDataJson:nil];
}

- (id)initWithQuizDataJson:(NSString *)dataJson
{
    return [self initWithQuizDataJson:dataJson startDate:nil completionDate:nil];
}

- (id)initWithQuizDataJson:(NSString *)dataJson startDate:(NSDate *)startDate completionDate:(NSDate *)completionDate
{
    if (dataJson) {
        
        NSData *jsonData = [dataJson dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                       options:NSJSONReadingAllowFragments
                                                                         error:&error];
        
        self.id = dataDictionary[@"id"];
        self.sheet = dataDictionary[@"sheet"];
        self.number = dataDictionary[@"number"];
        self.dataJson = dataJson;
        self.dataDictionary = dataDictionary;
        self.startDate = startDate;
        self.completionDate = completionDate;
    }
    return self;
    
}

@end
