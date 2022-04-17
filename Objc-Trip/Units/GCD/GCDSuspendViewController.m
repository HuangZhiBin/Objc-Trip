//
//  GCDSuspendViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/17.
//

#import "GCDSuspendViewController.h"
#import "GCDLogger.h"

@interface GCDSuspendViewController ()

@end

@implementation GCDSuspendViewController{
    GCDLogger *logger;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    logger = [[GCDLogger alloc] init];
}

-(wait)testSuspendResume{
    [logger reset];
    
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:3];
        [self->logger addStep:1];
    });
    
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:3];
        [self->logger addStep:2];
    });
    
    [logger addStep:3];
    [NSThread sleepForTimeInterval:1];
    
    [logger addStep:4];
    dispatch_suspend(queue);
    
    [NSThread sleepForTimeInterval:3];
    [logger addStep:5];
    
    dispatch_resume(queue);
    
    [self->logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isOrderedBySteps:@"3=4=1=5=2"], @"顺序执行");
        waitSuccess;
    } delay:4];
    
    returnWait;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
