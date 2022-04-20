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

-(waiter)testSuspendResume{
    [logger reset];
    
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        sleep(3);
        [self->logger addStep:1];
    });
    
    dispatch_async(queue, ^{
        [self->logger addStep:2];
    });
    
    [logger addStep:3];
    
    dispatch_suspend(queue);
    
    [logger addStep:4];
    
    dispatch_resume(queue);
    
    [self->logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isOrderedBySteps:@"3=4=1=2"], @"顺序执行");
        waitSuccess;
    } delay:4];
    
    returnWait;
}

-(waiter)test_block_cancel{
    [logger reset];
    
    dispatch_queue_t queue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_block_t block1 = dispatch_block_create(0, ^{
        [self->logger addStep:1];
    });
    
    dispatch_block_t block2 = dispatch_block_create(0, ^{
        [self->logger addStep:2];
    });
    
    dispatch_block_t block3 = dispatch_block_create(0, ^{
        [self->logger addStep:3];
    });
    
    // INFO: 在执行block之前先cancel
    dispatch_block_cancel(block1);
    
    dispatch_async(queue, block1);
    dispatch_async(queue, block2);
    dispatch_async(queue, block3);
    
    [self->logger check:^(NSArray * _Nonnull steps) {
        NSAssert(steps.count == 2, @"步骤1不执行");
        NSAssert([steps isRandomBySteps:@"2=3"], @"随机执行");
        waitSuccess;
    } delay:1];
    
    returnWait;
}

-(waiter)test_block_cancel2{
    [logger reset];
    
    dispatch_queue_t queue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_block_t block1 = dispatch_block_create(0, ^{
        [self->logger addStep:1];
    });
    
    dispatch_block_t block2 = dispatch_block_create(0, ^{
        [self->logger addStep:2];
    });
    
    dispatch_block_t block3 = dispatch_block_create(0, ^{
        [self->logger addStep:3];
    });
    
    dispatch_async(queue, block1);
    dispatch_async(queue, block2);
    dispatch_async(queue, block3);
    
    // INFO: 在block添加到queue之后cancel，cancel可能会失效
    dispatch_block_cancel(block1);
    
    [self->logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isRandomBySteps:@"1=2=3"] || [steps isRandomBySteps:@"2=3"], @"随机执行");
        waitSuccess;
    } delay:1];
    
    returnWait;
}

-(waiter)test_cancel_excecuting{
    [logger reset];
    
    dispatch_queue_t queue = dispatch_queue_create("concurrent", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_block_t block1 = dispatch_block_create(0, ^{
        for(int idx = 0; idx < 3; idx++){
            [self->logger addStep:idx+1];
            sleep(1);
        }
    });
    
    dispatch_async(queue, block1);
    
    // INFO: 已经执行的任务无法停止
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_block_cancel(block1);
    });
    
    [self->logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isOrderedBySteps:@"1=2=3"], @"顺序执行");
        waitSuccess;
    } delay:5];
    
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
