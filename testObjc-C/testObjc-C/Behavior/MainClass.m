

#import "MainClass.h"

@implementation MainClass

+ (void) whoAreYou
{
    NSLog(@"whoAreYou");
}

- (void)sayHello
{
    NSLog(@"Hello world");
}

- (void)say: (NSString*) string
{
    NSLog(@"%@", string);
}

-(void)say: (NSString*) string1 and: (NSString*) string2
{
    NSLog(@"%@, %@", string1, string2);
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (NSString*) saySomeString
{
    return [NSString stringWithFormat: @"Текущая дата и время: %@", [NSDate date]];
}

- (NSString*) sayString
{
    NSString* string = [self saySomeString];
    
    return string;
}

@end
