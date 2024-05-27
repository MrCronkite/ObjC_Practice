

#import "Apps.h"

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

- (NSString*) sayString
{
    return  @"Hello";
}

@end
