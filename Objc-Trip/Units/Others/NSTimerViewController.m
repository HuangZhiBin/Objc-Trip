//
//  NSTimerViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/18.
//

#import "NSTimerViewController.h"
#import "GCDLogger.h"
#import "TimerViewController.h"
#import "InfiniteScrollViewController.h"
#import "SVProgressHUD.h"
@interface NSTimerViewController ()

@end

@implementation NSTimerViewController{
    NSTimer *_timer;
    GCDLogger *logger;
}

-(NSDictionary*)redirect{
    return @{
        @"testRunMode": @[ @"InfiniteScrollViewController", @"testRunMode" ],
        @"testScheduledLeak1": @[ @"TimerViewController", @"testScheduledLeak1" ],
        @"testScheduledLeak2": @[ @"TimerViewController", @"testScheduledLeak2" ],
        @"testTimerWithLeak1": @[ @"TimerViewController", @"testTimerWithLeak1" ],
        @"testTimerWithLeak2": @[ @"TimerViewController", @"testTimerWithLeak2" ],
        @"testTimerWithLeak3": @[ @"TimerViewController", @"testTimerWithLeak3" ],
        @"testTimerWithLeak4": @[ @"TimerViewController", @"testTimerWithLeak4" ],
        @"testBreakInterReferrence": @[ @"TimerViewController", @"testSolveLeak" ],
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    logger = [[GCDLogger alloc] init];
    // Do any additional setup after loading the view.
}

-(void)groupTime{}

-(waiter)testTimeAccuracy{
    [logger reset];
    
    // INFO: NSTimer在每一次的runloop中会被处理，但当runloop中有其他比较多的耗时操作，且操作时间超过了NSTimer的间隔，那么这一次的NSTimer就会被延后处理。导致不准确
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(logInfo:) userInfo:@1 repeats:NO];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // INFO: NSTimer放入子线程，并手动开启子线程的runloop。当前runloop中没有其他耗时操作，所以也会相对准确
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(logInfo:) userInfo:@2 repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
    
    // 耗时操作
    for(int i = 0; i < 10000000; i++){
        NSString *str = [NSString stringWithFormat:@"%@", @"Hello it's me"];
    }
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"2=1"], @"按照顺序执行");
        waitSuccess;
    } delay:2];
    
    returnWait;
}

-(void)groupMode{}

-(void)testRunMode{
    [SVProgressHUD showInfoWithStatus:@"两秒内拖住视图"];
    InfiniteScrollViewController *vc = [[InfiniteScrollViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)groupLeak{}

-(waiter)testScheduledLeak1{
    TimerViewController *vc = [[TimerViewController alloc] init];
    vc.checkDellocCallback = ^(BOOL isDealloc){
        NSAssert(!isDealloc, @"内存泄漏");
        waitSuccess;
    };
    vc.testcase = @"testScheduledLeak1";
    [self.navigationController pushViewController:vc animated:YES];
    
    returnWait;
}

-(waiter)testScheduledLeak2{
    TimerViewController *vc = [[TimerViewController alloc] init];
    vc.checkDellocCallback = ^(BOOL isDealloc){
        NSAssert(isDealloc, @"内存不泄漏");
        waitSuccess;
    };
    vc.testcase = @"testScheduledLeak2";
    [self.navigationController pushViewController:vc animated:YES];
    
    returnWait;
}

-(waiter)testTimerWithLeak1{
    TimerViewController *vc = [[TimerViewController alloc] init];
    vc.checkDellocCallback = ^(BOOL isDealloc){
        NSAssert(!isDealloc, @"内存泄漏");
        waitSuccess;
    };
    vc.testcase = @"testTimerWithLeak1";
    [self.navigationController pushViewController:vc animated:YES];
    
    returnWait;
}

-(waiter)testTimerWithLeak2{
    TimerViewController *vc = [[TimerViewController alloc] init];
    vc.checkDellocCallback = ^(BOOL isDealloc){
        NSAssert(isDealloc, @"内存不泄漏");
        waitSuccess;
    };
    vc.testcase = @"testTimerWithLeak2";
    [self.navigationController pushViewController:vc animated:YES];
    
    returnWait;
}

-(waiter)testTimerWithLeak3{
    TimerViewController *vc = [[TimerViewController alloc] init];
    vc.checkDellocCallback = ^(BOOL isDealloc){
        NSAssert(isDealloc, @"内存不泄漏");
        waitSuccess;
    };
    vc.testcase = @"testTimerWithLeak3";
    [self.navigationController pushViewController:vc animated:YES];
    
    returnWait;
}

-(waiter)testTimerWithLeak4{
    TimerViewController *vc = [[TimerViewController alloc] init];
    vc.checkDellocCallback = ^(BOOL isDealloc){
        NSAssert(!isDealloc, @"内存泄漏");
        waitSuccess;
    };
    vc.testcase = @"testTimerWithLeak4";
    [self.navigationController pushViewController:vc animated:YES];
    
    returnWait;
}

-(void)groupSolveLeak{}

-(waiter)testBreakInterReferrence{
    TimerViewController *vc = [[TimerViewController alloc] init];
    vc.checkDellocCallback = ^(BOOL isDealloc){
        NSAssert(isDealloc, @"内存不泄漏");
        waitSuccess;
    };
    vc.testcase = @"testSolveLeak";
    [self.navigationController pushViewController:vc animated:YES];
    
    returnWait;
}

-(void)logInfo:(NSTimer *)timer{
    [logger addStep:[timer.userInfo intValue]];
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
