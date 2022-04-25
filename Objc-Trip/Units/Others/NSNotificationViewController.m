//
//  NSNotificationViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/25.
//

#import "NSNotificationViewController.h"
#import "GCDLogger.h"

@interface NSNotificationViewController ()

@end

@implementation NSNotificationViewController{
    GCDLogger *logger;
}
#define XYNotificationTestName @"XYNotificationTestName"
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    logger = [[GCDLogger alloc] init];
}

- (waiter)testPostNotification {
    [logger reset];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progress) name:XYNotificationTestName object:nil];
    [logger addStep:1];
    [[NSNotificationCenter defaultCenter] postNotificationName:XYNotificationTestName object:nil];
    [logger addStep:2];
    
    // INFO: 通知产生时，通知中心会一直等待所有的观察者都收到并且处理通知结束，才会返回到发送通知的地方继续执行后边的代码
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isOrderedBySteps:@"1=3=4=2"], @"");
        [self removeObserver];
        waitSuccess;
    } delay:0];
    
    returnWait;
}

-(waiter)testNSNotificationQueue_ASAP {
    [logger reset];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progress) name:XYNotificationTestName object:nil];
    NSNotification *notification = [NSNotification notificationWithName:XYNotificationTestName object:nil];
    [logger addStep:1];
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostASAP];
    [logger addStep:2];
    
    // INFO: NSPostASAP异步处理
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isOrderedBySteps:@"1=2=3=4"], @"");
        [self removeObserver];
        waitSuccess;
    } delay:0];
    
    returnWait;
}

-(waiter)testNSNotificationQueue_Idle {
    [logger reset];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progress) name:XYNotificationTestName object:nil];
    NSNotification *notification = [NSNotification notificationWithName:XYNotificationTestName object:nil];
    [logger addStep:1];
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostWhenIdle];
    [logger addStep:2];
    
    // INFO: NSPostWhenIdle异步处理
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isOrderedBySteps:@"1=2=3=4"], @"");
        [self removeObserver];
        waitSuccess;
    } delay:0];
    
    returnWait;
}

-(waiter)testNSNotificationQueue_Now {
    [logger reset];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progress) name:XYNotificationTestName object:nil];
    NSNotification *notification = [NSNotification notificationWithName:XYNotificationTestName object:nil];
    [logger addStep:1];
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostNow];
    [logger addStep:2];
    
    // INFO: NSPostNow同步处理
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isOrderedBySteps:@"1=3=4=2"], @"");
        [self removeObserver];
        waitSuccess;
    } delay:0];
    
    returnWait;
}

- (void)progress {
    [logger addStep:3];
    sleep(3);
    [logger addStep:4];
}

-(void)removeObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
