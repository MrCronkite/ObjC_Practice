

#import <Foundation/Foundation.h>

@interface MainClass : NSObject

+ (void) whoAreYou;

- (void)sayHello;
- (void)say: (NSString*) string;
- (void)say: (NSString*) string1 and: (NSString*) string2;
- (NSString*) sayString;

@end
