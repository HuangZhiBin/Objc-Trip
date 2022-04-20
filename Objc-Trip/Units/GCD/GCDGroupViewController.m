//
//  GCDGroupViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/16.
//

#import "GCDGroupViewController.h"
#import "GCDLogger.h"


@interface GCDGroupViewController ()

@end

@implementation GCDGroupViewController{
    GCDLogger *logger;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    logger = [[GCDLogger alloc] init];
}

-(waiter)testGroupNotify{
    [logger reset];
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    // 创建一个group
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, globalQueue, ^{
        [self->logger addStep:1];
    });
    
    dispatch_group_async(group, globalQueue, ^{
        [self->logger addStep:2];
    });
    
    dispatch_group_async(group, globalQueue, ^{
        [self->logger addStep:3];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self->logger check:^(NSArray * _Nonnull steps) {
            NSAssert(steps.count == 3, @"步骤执行完成");
            waitSuccess;
        } delay:0];
    });
    
    returnWait;
}

-(waiter)testGroupNotify2{
    [logger reset];
    
    dispatch_queue_t globalQueue = dispatch_queue_create("test1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t globalQueue2 = dispatch_queue_create("test2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, globalQueue, ^{
        [self->logger addStep:1];
    });
    
    dispatch_group_async(group, globalQueue2, ^{
        [self->logger addStep:2];
    });
    
    dispatch_group_async(group, globalQueue2, ^{
        [self->logger addStep:3];
    });
    
    // INFO: dispatch_group可以作用于多个队列
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self->logger check:^(NSArray * _Nonnull steps) {
            NSAssert(steps.count == 3, @"步骤执行完成");
            waitSuccess;
        } delay:0];
    });
    
    returnWait;
}

-(waiter)testGroupWait{
    [logger reset];
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    // 创建一个group
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, globalQueue, ^{
        [self->logger addStep:1];
    });
    
    dispatch_group_async(group, globalQueue, ^{
        [self->logger addStep:2];
    });
    
    dispatch_group_async(group, globalQueue, ^{
        [self->logger addStep:3];
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    [self->logger addStep:4];
    
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isRandomBySteps:@"1=2=3"], @"步骤123随机顺序完成");
        NSAssert([[steps lastObject] isEqual:@4], @"步骤4最后执行");
        waitSuccess;
    } delay:0];
    
    returnWait;
}

-(waiter)test_enter_leave{
    [logger reset];
    
    //创建调度组
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t globalQuene = dispatch_get_global_queue(0, 0);
    
    // INFO: dispatch_group_async(group, globalQuene, block) 等于 dispatch_group_enter(group) + dispatch_async(queue) + dispatch_group_leave(group)
    dispatch_group_enter(group);
    dispatch_async(globalQuene, ^{
        [self->logger addStep:1];
        dispatch_group_leave(group);
    });
    
    //任务2
    dispatch_group_enter(group);
    dispatch_async(globalQuene, ^{
        [self->logger addStep:2];
        dispatch_group_leave(group);
    });
    
    //任务3
    dispatch_group_enter(group);
    dispatch_async(globalQuene, ^{
        [self->logger addStep:3];
        dispatch_group_leave(group);
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isRandomBySteps:@"1=2=3"], @"随机执行");
        waitSuccess;
    } delay:0];
    
    returnWait;
}

@end
