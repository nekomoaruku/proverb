#import "I3ProverbQuiz.h"

@implementation I3ProverbQuiz

- (id)init
{
    return [self initWithQuizData:nil];
}

- (id)initWithQuizData:(NSDictionary *)quizData
{
    if (quizData) {
        self.id = quizData[@"id"];
        self.sheet = quizData[@"sheet"];
        self.number = quizData[@"number"];
        self.dataDictionary = quizData;
        self.completionDate = nil;
    }
    return self;
}

@end
