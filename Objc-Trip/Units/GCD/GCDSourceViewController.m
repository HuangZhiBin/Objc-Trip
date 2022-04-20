//
//  GCDSourceViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/17.
//

#import "GCDSourceViewController.h"
#import "GCDLogger.h"

@interface GCDSourceViewController ()

@end

@implementation GCDSourceViewController{
    GCDLogger *logger;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    logger = [[GCDLogger alloc] init];
}

-(waiter)testSourceTime{
    [logger reset];
    
    dispatch_queue_t queue = dispatch_queue_create("timeQueue", DISPATCH_QUEUE_CONCURRENT);
    // INFO: 系统级定时器，精准
    dispatch_source_t t_source =  dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0,0, queue);
    dispatch_source_set_timer(t_source, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0);
    // 设置源数据回调
    dispatch_source_set_event_handler(t_source, ^{
        [self->logger addStep:1];
        dispatch_suspend(t_source);
    });
    // INFO: dispatch_source_t必须resume才能执行
    dispatch_resume(t_source);
    [logger addStep:2];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"2=1"], @"按照顺序执行");
        waitSuccess;
    } delay:2];
    
    returnWait;
}

@end
