

#import "ViewController.h"
#import "Apps.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    MainClass *mainClassInstance = [[MainClass alloc] init];
    [mainClassInstance sayHello];
    [mainClassInstance say:@"How are you"];
    [mainClassInstance say:@"i am" and:@"vlad"];
    
    NSLog(@"%@", [mainClassInstance sayString]);
    
    [MainClass whoAreYou];
}

@end

