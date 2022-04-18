//
//  GCDBarrierViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/17.
//

#import "GCDBarrierViewController.h"
#import "GCDLogger.h"
@interface GCDBarrierViewController ()

@end

@implementation GCDBarrierViewController{
    GCDLogger *logger;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    logger = [[GCDLogger alloc] init];
}

-(waiter)test_barrier_async{
    [logger reset];
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("xkQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrentQueue, ^{
        sleep(2);
        [self->logger addStep:1];
    });
    
    dispatch_async(concurrentQueue, ^{
        sleep(1);
        [self->logger addStep:2];
    });
    
    dispatch_barrier_async(concurrentQueue, ^{
        [self->logger addStep:3];
    });
    
    dispatch_async(concurrentQueue, ^{
        [self->logger addStep:4];
    });
    
    [logger addStep:5];
    
    [self->logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isOrderedBySteps:@"2=1=3=4"], @"步骤3在步骤1、2完成后执行，步骤4最后执行");
        NSAssert([steps isRandomBySteps:@"3=5"], @"步骤3、5随机执行");
        waitSuccess;
    } delay:3];
    
    returnWait;
}

-(waiter)test_barrier_sync{
    [logger reset];
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("xkQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(concurrentQueue, ^{
        sleep(2);
        [self->logger addStep:1];
    });
    
    dispatch_async(concurrentQueue, ^{
        sleep(1);
        [self->logger addStep:2];
    });
    
    dispatch_barrier_sync(concurrentQueue, ^{
        [self->logger addStep:3];
    });
    
    dispatch_async(concurrentQueue, ^{
        [self->logger addStep:4];
    });
    
    [logger addStep:5];
    
    [self->logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isOrderedBySteps:@"2=1=3=4"], @"步骤3在步骤1、2完成后执行，步骤4最后执行");
        NSAssert([steps isOrderedBySteps:@"3=5"], @"步骤3、5顺序执行");
        waitSuccess;
    } delay:3];
    
    returnWait;
}

-(waiter)test_barrier_global{
    [logger reset];
    
    // INFO: dispatch_barrier 在全局并行队列无效
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(concurrentQueue, ^{
        sleep(2);
        [self->logger addStep:1];
    });
    
    dispatch_async(concurrentQueue, ^{
        sleep(1);
        [self->logger addStep:2];
    });
    
    dispatch_barrier_sync(concurrentQueue, ^{
        [self->logger addStep:3];
    });
    
    dispatch_async(concurrentQueue, ^{
        [self->logger addStep:4];
    });
    
    [self->logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isOrderedBySteps:@"3=4=2=1"], @"顺序执行");
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
