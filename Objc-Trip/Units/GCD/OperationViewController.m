//
//  OperationViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/17.
//

#import "OperationViewController.h"
#import "GCDLogger.h"
#import "MyOperation.h"

@interface OperationViewController ()

@end

@implementation OperationViewController{
    GCDLogger *logger;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    logger = [[GCDLogger alloc] init];
}

-(void)groupOperationType{}

-(waiter)testInvocationOperation{
    [logger reset];
    
    // INFO: 使用NSInvocationOperation可避免为应用程序中的每个任务定义大量自定义操作对象
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(operation) object:nil];
    [operation start];
    
    [logger addStep:4];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"1=2=3=4"], @"顺序同步执行");
        waitSuccess;
    } delay:0];
    
    returnWait;
}

-(waiter)testBlockOperation{
    [logger reset];
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [self operation];
    }];
    
    [operation start];
    
    [logger addStep:4];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"1=2=3=4"], @"顺序同步执行");
        waitSuccess;
    } delay:0];
    
    returnWait;
}

-(waiter)testBlockOperation2{
    [logger reset];
    
    // INFO: 调用了addExecutionBlock方法添加了组个多的任务后，开启新的线程，任务是并发执行的
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        // INFO: block可能是main也可能是新的线程
        [self->logger addStep:1];
    }];
    [operation addExecutionBlock:^{
        [self->logger addStep:2];
    }];
    [operation addExecutionBlock:^{
        [self->logger addStep:3];
    }];
    [operation addExecutionBlock:^{
        [self->logger addStep:4];
    }];
    
    [operation start];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isRandomBySteps:@"1=2=3=4"], @"随机执行");
        waitSuccess;
    } delay:1];
    
    returnWait;
}

-(waiter)testCustomOperation{
    [logger reset];
    
    MyOperation *operation = [[MyOperation alloc] initWith:^{
        [self operation];
    }];
    
    [operation start];
    
    [logger addStep:4];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"1=2=3=4"], @"顺序同步执行");
        waitSuccess;
    } delay:0];
    
    returnWait;
}

-(void)operation{
    NSAssert([[NSThread currentThread] isMainThread], @"在主线程执行");
    for (int i = 0; i < 3; i++) {
        [logger addStep:i+1];
        sleep(1);
    }
}

-(void)groupOperationQueue{}

-(waiter)testMainQueue{
    [logger reset];
    
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSAssert([[NSThread currentThread] isMainThread], @"在主线程执行");
        [self->logger addStep:1];
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [self->logger addStep:2];
    }];
    
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperationWithBlock:^{
        [self->logger addStep:3];
    }];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"1=2=3"], @"顺序异步执行");
        waitSuccess;
    } delay:1];
    
    returnWait;
}

-(waiter)testCustomQueue{
    [logger reset];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSAssert(![[NSThread currentThread] isMainThread], @"不在主线程执行");
        [self->logger addStep:1];
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [self->logger addStep:2];
    }];
    
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    [queue addOperationWithBlock:^{
        [self->logger addStep:3];
    }];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isRandomBySteps:@"1=2=3"], @"随机异步执行");
        waitSuccess;
    } delay:1];
    
    returnWait;
}

-(void)groupMaxOperationNum{}

-(waiter)testMaxConcurrentOperationCount1{
    [logger reset];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // INFO: 即使指定setMaxConcurrentOperationCount==1，仍然是异步执行
    [queue setMaxConcurrentOperationCount:1];
    [queue addOperationWithBlock:^{
        [self->logger addStep:1];
    }];
    [queue addOperationWithBlock:^{
        [self->logger addStep:2];
    }];
    [queue addOperationWithBlock:^{
        [self->logger addStep:3];
    }];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"1=2=3"], @"顺序异步执行");
        waitSuccess;
    } delay:1];
    
    returnWait;
}

-(waiter)testMaxConcurrentOperationCount2{
    [logger reset];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    // INFO: 一个队列中能够同时执行的任务的数量
    [queue setMaxConcurrentOperationCount:3];
    [queue addOperationWithBlock:^{
        [self->logger addStep:1];
    }];
    [queue addOperationWithBlock:^{
        [self->logger addStep:2];
    }];
    [queue addOperationWithBlock:^{
        [self->logger addStep:3];
    }];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isRandomBySteps:@"1=2=3"], @"随机异步执行");
        waitSuccess;
    } delay:1];
    
    returnWait;
}

-(void)groupOperationCommunication{}

-(waiter)testOperationSwitch{
    [logger reset];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        [self->logger addStep:1];
    }];
    [queue addOperationWithBlock:^{
        [self->logger addStep:2];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self->logger addStep:0];
        }];
    }];
    [queue addOperationWithBlock:^{
        [self->logger addStep:3];
    }];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isRandomBySteps:@"1=2=3"], @"随机异步执行");
        NSAssert([steps isOrderedBySteps:@"2=0"], @"顺序执行");
        waitSuccess;
    } delay:1];
    
    returnWait;
}

-(void)groupOperationOrder{}

-(waiter)testOperationDependency{
    [logger reset];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [self->logger addStep:1];
    }];
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [self->logger addStep:2];
    }];
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [self->logger addStep:3];
    }];
    
    // operation1依赖于operation2和operation3，则先执行operation2和operation3，然后执行operation1
    [operation1 addDependency:operation2];
    [operation1 addDependency:operation3];
    [operation1 removeDependency:operation2];
    NSArray *opList = @[operation1,operation2,operation3];
    [queue addOperations:opList waitUntilFinished:YES];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isRandomBySteps:@"2=3"], @"随机异步执行");
        NSAssert([steps isOrderedBySteps:@"3=1"], @"顺序异步执行");
        waitSuccess;
    } delay:0];
    
    returnWait;
}

-(waiter)testOperationPriority{
    [logger reset];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [self->logger addStep:1];
    }];
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [self->logger addStep:2];
    }];
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [self->logger addStep:3];
    }];
    
    // operation1依赖于operation2和operation3，则先执行operation2和operation3，然后执行operation1
    operation3.queuePriority = NSOperationQueuePriorityVeryHigh;
    NSArray *opList = @[operation1,operation2,operation3];
    [queue addOperations:opList waitUntilFinished:YES];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps[0] isEqual:@3], @"步骤3首先执行");
        waitSuccess;
    } delay:0];
    
    returnWait;
}

-(waiter)testDependencyPriority{
    [logger reset];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [self->logger addStep:1];
    }];
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [self->logger addStep:2];
    }];
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [self->logger addStep:3];
    }];
    
    [operation1 addDependency:operation2];
    [operation1 addDependency:operation3];
    operation1.queuePriority = NSOperationQueuePriorityVeryHigh;
    NSArray *opList = @[operation1,operation2,operation3];
    [queue addOperations:opList waitUntilFinished:YES];
    
    // INFO: 即使将operation1的优先级设置为最高，依然是最后执行的，因为operation1依赖于operation2和operation3
    [logger check:^(NSArray *steps){
        NSAssert([steps.lastObject isEqual:@1], @"步骤1最后执行");
        waitSuccess;
    } delay:0];
    
    returnWait;
}

-(void)groupCancel{}

-(waiter)testCancel1{
    [logger reset];
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [self->logger addStep:1];
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [self->logger addStep:2];
    }];
    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [self->logger addStep:3];
    }];
    
    [operation1 cancel];
    
    [operation1 start];
    [operation2 start];
    [operation3 start];
    
    [self->logger check:^(NSArray * _Nonnull steps) {
        NSAssert(steps.count == 2, @"步骤1不执行");
        NSAssert([steps isRandomBySteps:@"2=3"], @"随机执行");
        waitSuccess;
    } delay:1];
    
    returnWait;
}

-(waiter)testCancel2{
    [logger reset];
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [self->logger addStep:1];
    }];
    
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [self->logger addStep:2];
    }];
    
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [self->logger addStep:3];
    }];
    
    [operation1 start];
    [operation2 start];
    [operation3 start];
    
    [operation1 cancel];
    
    // INFO: operation1已经开始执行，cancel失效
    [self->logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isRandomBySteps:@"1=2=3"], @"随机执行");
        waitSuccess;
    } delay:1];
    
    returnWait;
}

-(void)groupCompletion{}

-(waiter)testQueueFinished{
    [logger reset];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        [self->logger addStep:1];
    }];
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        [self->logger addStep:2];
    }];
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        [self->logger addStep:3];
    }];
    
    NSArray *opList = @[operation1,operation2,operation3];
    [queue addOperations:opList waitUntilFinished:YES];
    
    [self->logger addStep:4];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps.lastObject isEqual:@4], @"步骤4最后执行");
        waitSuccess;
    } delay:0];
    
    returnWait;
}

-(waiter)testOperationFinished{
    [logger reset];
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        // INFO: block可能是main也可能是新的线程
        [self->logger addStep:1];
    }];
    [operation addExecutionBlock:^{
        [self->logger addStep:2];
    }];
    [operation addExecutionBlock:^{
        [self->logger addStep:3];
    }];
    
    [operation setCompletionBlock:^ {
        [self->logger addStep:4];
    }];
    
    [operation start];
    
    [logger check:^(NSArray *steps){
        NSAssert([steps.lastObject isEqual:@4], @"步骤4最后执行");
        waitSuccess;
    } delay:1];
    
    returnWait;
}

@end
