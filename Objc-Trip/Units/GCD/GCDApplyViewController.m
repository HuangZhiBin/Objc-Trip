//
//  GCDApplyViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/17.
//

#import "GCDApplyViewController.h"
#import "GCDLogger.h"

@interface GCDApplyViewController ()

@end

@implementation GCDApplyViewController{
    GCDLogger *logger;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    logger = [[GCDLogger alloc] init];
}

-(waiter)testApplyConcurrent{
    [logger reset];
    
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    // INFO: dispatch_apply函数会等待所有的处理结束
    // INFO: dispatch_apply + concurrent = 随机顺序
    dispatch_apply(4, queue, ^(size_t i) {
        [self->logger addStep:i+1];
    });
    [logger addStep:5];
    
    [self->logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isRandomBySteps:@"1=2=3=4"], @"步骤1234随机执行");
        NSAssert([[steps lastObject] isEqual:@5], @"步骤5最后执行");
        waitSuccess;
    } delay:0];
    
    returnWait;
}

-(waiter)testApplySerial{
    [logger reset];
    
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    // INFO: dispatch_apply + serial = 顺序顺序
    dispatch_apply(4, queue, ^(size_t i) {
        [self->logger addStep:i+1];
    });
    [logger addStep:5];
    
    [self->logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isOrderedBySteps:@"1=2=3=4"], @"顺序执行");
        NSAssert([[steps lastObject] isEqual:@5], @"步骤5最后执行");
        waitSuccess;
    } delay:0];
    
    returnWait;
}

-(waiter)testApplyScene{
    [logger reset];
    
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    NSArray *dictArray = @[ @1, @2, @3, @4 ];
    dispatch_async(queue, ^{
        dispatch_apply(dictArray.count, queue,  ^(size_t index){
            [self->logger addStep:[dictArray[index] intValue]];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->logger addStep:5];
        });
    });
    
    [self->logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isRandomBySteps:@"1=2=3=4"], @"步骤1234随机执行");
        NSAssert([[steps lastObject] isEqual:@5], @"步骤5最后执行");
        waitSuccess;
    } delay:1];
    
    returnWait;
}

@end
