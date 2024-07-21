

#import "ViewController.h"
#import "Child.h"
#import "testObjc_C-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    Child *childClassInstance = [[Child alloc] init];
    [childClassInstance sayHello];
    [childClassInstance say:@"How are you"];
    [childClassInstance say:@"i am" and:@"vlad"];
    
    NSLog(@"%@", [childClassInstance sayString]);
    ModerChild *modernChildInstance = [[ModerChild alloc] init];
    NSLog(@"%@", [modernChildInstance sayString]);
    
    [Child whoAreYou];
}

@end

