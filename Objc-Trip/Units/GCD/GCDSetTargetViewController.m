//
//  GCDSetTargetViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/16.
//

#import "GCDSetTargetViewController.h"
#import "GCDLogger.h"

@interface GCDSetTargetViewController ()

@end

@implementation GCDSetTargetViewController{
    GCDLogger *logger;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    logger = [[GCDLogger alloc] init];
}

-(waiter)testMultiSerial{
    [logger reset];
    
    dispatch_queue_t q1 = dispatch_queue_create("q1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t q2 = dispatch_queue_create("q2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t q3 = dispatch_queue_create("q3", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(q1, ^{
        [self->logger addStep:1];
    });
    
    dispatch_async(q2, ^{
        [self->logger addStep:2];
    });
    
    dispatch_async(q3, ^{
        [self->logger addStep:3];
    });
    
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isRandomBySteps:@"1=2=3"], @"步骤123随机执行") ;
        waitSuccess;
    } delay:1];
    
    returnWait;
}

-(waiter)testMultiConcurrent{
    [logger reset];
    
    dispatch_queue_t q1 = dispatch_queue_create("q1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t q2 = dispatch_queue_create("q2", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t q3 = dispatch_queue_create("q3", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(q1, ^{
        [self->logger addStep:1];
    });
    
    dispatch_async(q2, ^{
        [self->logger addStep:2];
    });
    
    dispatch_async(q3, ^{
        [self->logger addStep:3];
    });
    
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isRandomBySteps:@"1=2=3"], @"步骤123随机执行") ;
        waitSuccess;
    } delay:1];
    
    returnWait;
}

-(waiter)testSetTarget{
    [logger reset];
    
    dispatch_queue_t q1 = dispatch_queue_create("q1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t q2 = dispatch_queue_create("q2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t q3 = dispatch_queue_create("q3", DISPATCH_QUEUE_SERIAL);

    // INFO: 多线程下 PRIORITY_BACKGROUND 优先级较低
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_set_target_queue(q1, globalQueue);

    dispatch_async(q1, ^{
        [self->logger addStep:1];
    });

    dispatch_async(q2, ^{
        [self->logger addStep:2];
    });

    dispatch_async(q3, ^{
        [self->logger addStep:3];
    });
    
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert([[steps lastObject] intValue] == 1, @"步骤1最后执行");
        waitSuccess;
    } delay:1];
    
    returnWait;
}

-(waiter)testSetTarget2{
    [logger reset];
    
    dispatch_queue_t q1 = dispatch_queue_create("q1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t q2 = dispatch_queue_create("q2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t q3 = dispatch_queue_create("q3", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t q4 = dispatch_queue_create("q4", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t q5 = dispatch_queue_create("q5", DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_t targetQueue = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
    
    dispatch_set_target_queue(q1, targetQueue);
    dispatch_set_target_queue(q2, targetQueue);
    dispatch_set_target_queue(q3, targetQueue);
    dispatch_set_target_queue(q4, targetQueue);
    dispatch_set_target_queue(q5, targetQueue);
    

    dispatch_async(q1, ^{
        [self->logger addStep:1];
    });

    dispatch_async(q2, ^{
        [self->logger addStep:2];
    });

    dispatch_async(q3, ^{
        [self->logger addStep:3];
    });

    dispatch_async(q4, ^{
        [self->logger addStep:4];
    });

    dispatch_async(q5, ^{
        [self->logger addStep:5];
    });
    
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isOrderedBySteps:@"1=2=3=4=5"], @"步骤12345顺序执行");
        waitSuccess;
    } delay:1];
    
    returnWait;
}

@end
