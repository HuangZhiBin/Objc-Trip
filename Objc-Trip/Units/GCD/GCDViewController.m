//
//  GCDViewController.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/8.
//

#import "GCDViewController.h"

#import "GCDLogger.h"

@interface GCDViewController ()

@end

@implementation GCDViewController{
    GCDLogger *logger;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    logger = [[GCDLogger alloc] init];
}

-(void)groupBasic{}

-(void)test_main_sync🔥{
    if(![logger shouldEnter])return;
    
    [logger addStep:1];
    // INFO:sync阻塞当前线程
    SafeExit();
    dispatch_sync(dispatch_get_main_queue(), ^{
        // INFO:永远执行不到这里
        [self->logger addStep:2];
    });
}

-(void)test_main_async{
    if(![logger shouldEnter])return;
    
    [logger addStep:1];
    // INFO:async不阻塞当前线程
    dispatch_async(dispatch_get_main_queue(), ^{
        // INFO:不开辟新线程
        NSAssert([[NSThread currentThread] isMainThread], @"在主线程");
        [self->logger addStep:2];
    });
    [logger addStep:3];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"1=3=2"], @"按照顺序执行");
    } delay:1];
}

-(void)test_serial_sync{
    if(![logger shouldEnter])return;
    
    dispatch_queue_t serialQueue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    [logger addStep:1];
    dispatch_sync(serialQueue, ^{
        NSAssert([[NSThread currentThread] isMainThread], @"在主线程");
        [self->logger addStep:2];
    });
    [logger addStep:3];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"1=2=3"], @"按照顺序执行");
    } delay:1];
}

-(void)test_serial_async{
    if(![logger shouldEnter])return;
    
    dispatch_queue_t serialQueue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    [logger addStep:1];
    dispatch_async(serialQueue, ^{
        NSAssert(![[NSThread currentThread] isMainThread], @"不在主线程");
        [self->logger addStep:2];
    });
    [logger addStep:3];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"1=3=2"], @"按照顺序执行");
    } delay:1];
}

-(void)test_concurrent_sync{
    if(![logger shouldEnter])return;
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    [logger addStep:1];
    dispatch_sync(concurrentQueue, ^{
        NSAssert([[NSThread currentThread] isMainThread], @"在主线程");
        [self->logger addStep:2];
    });
    [logger addStep:3];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"1=2=3"], @"按照顺序执行");
    } delay:1];
}

-(void)test_concurrent_async{
    if(![logger shouldEnter])return;
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    [logger addStep:1];
    
    dispatch_async(concurrentQueue, ^{
        NSAssert(![[NSThread currentThread] isMainThread], @"不在主线程");
        [self->logger addStep:2];
    });
    
    [logger addStep:3];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"1=3=2"], @"按照顺序执行");
    } delay:1];
}

-(void)groupMultiple{}

-(void)test_serial_sync_async{
    if(![logger shouldEnter])return;
    
    dispatch_queue_t serialQueue = dispatch_queue_create("test", DISPATCH_QUEUE_SERIAL);
    [logger addStep:1];
    dispatch_async(serialQueue, ^{
        [self->logger addStep:2];
    });
    [logger addStep:3];
    dispatch_sync(serialQueue, ^{
        [self->logger addStep:4];
    });
    [logger addStep:5];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"1=3=2=4=5"], @"按照顺序执行");
    } delay:1];
}

-(void)test_serial_multi_async{
    if(![logger shouldEnter])return;
    
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        [self->logger addStep:0];
    });
    
    for(NSInteger idx = 1; idx <= 10; idx++){
        dispatch_async(queue, ^{
            [self->logger addStep:idx];
        });
    }
    
    [logger addStep:11];
    
    [logger check:^(NSArray *steps){
        NSAssert(steps.count == 12, @"所有步骤都执行了");
        NSAssert([steps[0] isEqual:@0], @"第0步先执行，第11步顺序随机，可能在第1-10步之间或者前后");
        NSAssert([steps isOrderedBySteps:@"1=2=3=4=5=6=7=8=9=10"], @"第1-10步是按照顺序执行的");
    } delay:1];
}

-(void)test_concurrent_multi_sync{
    if(![logger shouldEnter])return;
    
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    
    for(NSInteger idx = 1; idx <= 10; idx++){
        dispatch_sync(queue, ^{
            [self->logger addStep:idx];
        });
    }
    
    [logger addStep:11];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"1=2=3=4=5=6=7=8=9=10"], @"第1-10步是按照顺序执行的");
        NSAssert([steps.lastObject isEqual:@11], @"第11步最后执行");
    } delay:1];
}

-(void)groupEmbed{}

-(void)test_serial_embed_lock🔥{
    if(![logger shouldEnter])return;
    
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        [self->logger addStep:1];
    });
    
    dispatch_async(queue, ^{
        // 执行下面的语句会crash
        SafeExit();
        dispatch_sync(queue, ^{
            [self->logger addStep:2];
        });
        [self->logger addStep:3];
    });
    
    [logger addStep:4];
}

-(void)test_concurrent_embed_sync{
    if(![logger shouldEnter])return;
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        [self->logger addStep:1];
        dispatch_sync(dispatch_get_global_queue(0, 0),^{
            [self->logger addStep:2];
        }) ;
        [self->logger addStep:3];
    });
    [logger addStep:4];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"1=2=3=4"], @"按照顺序执行");
    } delay:1];
}

-(void)test_concurrent_embed_async{
    if(![logger shouldEnter])return;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self->logger addStep:1];
        dispatch_async(dispatch_get_global_queue(0, 0),^{
            [self->logger addStep:2];
        });
        [self->logger addStep:3];
    });
    [logger addStep:4];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"4=1=3=2"], @"按照顺序执行");
    } delay:1];
}

-(void)test_main_embed_async{
    if(![logger shouldEnter])return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->logger addStep:1];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->logger addStep:2];
        });
        [self->logger addStep:3];
    });
    [logger addStep:4];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"4=1=3=2"], @"按照顺序执行");
    } delay:1];
}

-(void)groupPerformSelector{}

-(void)testPerformSelector_async{
    if(![logger shouldEnter])return;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSAssert(![[NSThread currentThread] isMainThread], @"不在主线程");
        // INFO: 这个⽅法要创建提交任务到runloop上的，⽽gcd底层创建的线程是默认没有开启对应runloop的，⽽主队列默认开启了runloop
        [self performSelector:@selector(log:) withObject:@1 afterDelay:0];
    });
    
    [logger check:^(NSArray *steps){
        NSAssert(steps.count == 0, @"步骤不执行");
    } delay:1];
}

-(void)testPerformSelector_sync{
    if(![logger shouldEnter])return;
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSAssert([[NSThread currentThread] isMainThread], @"在主线程");
        [self performSelector:@selector(log:) withObject:@1 afterDelay:0];
    });
    
    [logger check:^(NSArray *steps){
        NSAssert(steps.count == 1, @"步骤1执行");
    } delay:1];
}

-(void)testPerformSelector_after{
    if(![logger shouldEnter])return;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self->logger addStep:1];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->logger addStep:2];
    });
    [self performSelector:@selector(log:) withObject:@3];
    [self performSelector:@selector(log:) withObject:@4 afterDelay:0];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self->logger addStep:5];
    });
    [self log:@6];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"3=6=5=1=2=4"]
                 || [steps isOrderedBySteps:@"3=6=5=4=1=2"], @"按照顺序执行");
    } delay:1];
}

-(void)log:(NSNumber*)num{
    [logger addStep:[num intValue]];
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
