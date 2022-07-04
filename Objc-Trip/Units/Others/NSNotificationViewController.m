//
//  NSNotificationViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/25.
//

#import "NSNotificationViewController.h"
#import "GCDLogger.h"

#define XYNotificationTestName @"XYNotificationTestName"

@interface NSNotificationViewController ()

@end

@implementation NSNotificationViewController{
    GCDLogger *logger;
    NSString *threadName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    logger = [[GCDLogger alloc] init];
}

- (waiter)testPostNotification {
    [logger reset];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progress:) name:XYNotificationTestName object:nil];
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

-(void)groupNSNotificationQueue{}

-(waiter)testNSNotificationQueue_ASAP {
    [logger reset];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progress:) name:XYNotificationTestName object:nil];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progress:) name:XYNotificationTestName object:nil];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progress:) name:XYNotificationTestName object:nil];
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

-(void)groupNil{}

-(waiter)test_name_object {
    [logger reset];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSObject *obj = [NSObject new];
    // INFO: 只接收name为XYNotificationTestName并且object为obj的通知，缺一不可
    [center addObserver:self selector:@selector(progress:) name:XYNotificationTestName object:obj];
    [center postNotificationName:XYNotificationTestName object:nil];
    
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert(steps.count == 0, @"");
        [self removeObserver];
        waitSuccess;
    } delay:0];
    
    returnWait;
}

-(waiter)testNilName {
    [logger reset];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSObject *obj = [NSObject new];
    // INFO: 接收所有object为obj的通知
    [center addObserver:self selector:@selector(progress:) name:nil object:obj];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [center postNotificationName:@"TEST" object:obj];
    });
    
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isOrderedBySteps:@"3=4"], @"");
        [self removeObserver];
        waitSuccess;
    } delay:4];
    
    returnWait;
}

-(waiter)testNilObject {
    [logger reset];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSObject *obj = [NSObject new];
    // INFO: 接收所有name为XYNotificationTestName的通知
    [center addObserver:self selector:@selector(progress:) name:XYNotificationTestName object:nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [center postNotificationName:XYNotificationTestName object:obj];
    });
    
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isOrderedBySteps:@"3=4"], @"");
        [self removeObserver];
        waitSuccess;
    } delay:4];
    
    returnWait;
}

-(waiter)test_NilName_NilObject {
    [logger reset];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSObject *obj = [NSObject new];
    // INFO: 接收所有通知
    [center addObserver:self selector:@selector(progress:) name:nil object:nil];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [center postNotificationName:XYNotificationTestName object:obj];
    });
    
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isOrderedBySteps:@"3=4"], @"");
        [self removeObserver];
        waitSuccess;
    } delay:4];
    
    returnWait;
}

-(void)groupThread{}

-(waiter)testThread1 {
    [logger reset];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(progress:) name:XYNotificationTestName object:nil];
    [center postNotificationName:XYNotificationTestName object:nil];
    
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert(isMainThread(self->threadName), @"在主线程");
        [self removeObserver];
        waitSuccess;
    } delay:0];
    
    returnWait;
}

-(waiter)testThread2 {
    [logger reset];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(progress:) name:XYNotificationTestName object:nil];
    __block NSString *postThreadName;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        postThreadName = getThreadName([NSThread currentThread]);
        [center postNotificationName:XYNotificationTestName object:nil];
    });
    
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert(!isMainThread(self->threadName), @"不在主线程");
        NSAssert([postThreadName isEqualToString:self->threadName], @"在同一个子线程");
        [self removeObserver];
        waitSuccess;
    } delay:4];
    
    returnWait;
}

-(void)groupMulti{}

-(waiter)testMultiAddObservers {
    [logger reset];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    // INFO: 多次添加同一个通知，会多次通知回调
    [center addObserver:self selector:@selector(progress:) name:XYNotificationTestName object:nil];
    [center addObserver:self selector:@selector(progress:) name:XYNotificationTestName object:nil];
    [center postNotificationName:XYNotificationTestName object:nil];
    
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isOrderedBySteps:@"3=4=3=4"], @"");
        [self removeObserver];
        waitSuccess;
    } delay:0];
    
    returnWait;
}

- (void)progress:(NSNotification*)notification {
    threadName = getThreadName([NSThread currentThread]);
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
