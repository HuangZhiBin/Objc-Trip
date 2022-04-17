//
//  GCDSemaphoreViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/17.
//

#import "GCDSemaphoreViewController.h"
#import "GCDLogger.h"

@interface GCDSemaphoreViewController ()

@end

@implementation GCDSemaphoreViewController{
    GCDLogger *logger;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    logger = [[GCDLogger alloc] init];
}

- (wait)test_semaphore_create_with_1 {
    [logger reset];
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // INFO: 注意这个create里面的值
    dispatch_semaphore_t sem = dispatch_semaphore_create(1);
    NSMutableArray *array = [NSMutableArray array];
    for(int idx = 0; idx < 10; idx++){
        dispatch_async(queue, ^{
            // INFO: 信号值大于等于1继续执行，信号值-1
            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
            [array addObject:@(idx+1)];
            [self->logger addStep:idx+1];
            //  INFO: 信号值+1
            dispatch_semaphore_signal(sem);
        });
    }
    
    [self->logger check:^(NSArray * _Nonnull steps) {
        NSAssert(array.count == 10, @"addObject执行了10次");
        NSAssert([steps isRandomBySteps:@"1=2=3=4=5=6=7=8=9=10"], @"随机执行");
        waitSuccess;
    } delay:1];
    
    returnWait;
}

- (wait)test_semaphore_create_with_0 {
    [logger reset];
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    
    //任务1
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER); // 等待
        [self->logger addStep:1];
    });
    
    //任务2
    dispatch_async(queue, ^{
        [self->logger addStep:2];
        sleep(2);
        [self->logger addStep:3];
        dispatch_semaphore_signal(sem); // 发信号
    });
    
    [self->logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isOrderedBySteps:@"2=3=1"], @"顺序执行");
        waitSuccess;
    } delay:3];
    
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
