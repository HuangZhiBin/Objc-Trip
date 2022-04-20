//
//  LockViewController.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/10.
//

#import "LockViewController.h"
#import <libkern/OSAtomic.h>
#import "GCDLogger.h"
#import <pthread.h>

@interface LockViewController ()

@end

@implementation LockViewController{
    GCDLogger *logger;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    logger = [[GCDLogger alloc] init];
    // @synchronized、 NSLock、NSRecursiveLock、NSCondition、NSConditionLock、pthread_mutex、dispatch_semaphore、OSSpinLock
}

-(waiter)testSpinLock{
    [logger reset];
    
    __block OSSpinLock oslock = OS_SPINLOCK_INIT;
    
    for(int idx = 0; idx < 2; idx++){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self->logger addStep:(idx + 1) * 100 + 1];
            OSSpinLockLock(&oslock);
            [self->logger addStep:(idx + 1) * 100 + 2];
            sleep(2);
            [self->logger addStep:(idx + 1) * 100 + 3];
            OSSpinLockUnlock(&oslock);
            [self->logger addStep:(idx + 1) * 100 + 4];
        });
    }
    
    [logger check:^(NSArray *steps){
        // 线程1先执行
        if([steps isOrderedBySteps:@"102=202"]){
            NSAssert([steps isOrderedBySteps:@"102=103=202=203"], @"按照顺序执行");
        }
        else{
            NSAssert([steps isOrderedBySteps:@"202=203=102=103"], @"按照顺序执行");
        }
        waitSuccess;
    } delay:5];
    
    returnWait;
}

-(waiter)test_pthread_mutex{
    [logger reset];
    
    static pthread_mutex_t pLock;
    pthread_mutex_init(&pLock, NULL);
    
    for(int idx = 0; idx < 2; idx++){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self->logger addStep:(idx + 1) * 100 + 1];
            pthread_mutex_lock(&pLock);
            [self->logger addStep:(idx + 1) * 100 + 2];
            sleep(2);
            [self->logger addStep:(idx + 1) * 100 + 3];
            pthread_mutex_unlock(&pLock);
            [self->logger addStep:(idx + 1) * 100 + 4];
        });
    }
    
    [logger check:^(NSArray *steps){
        // 线程1先执行
        if([steps isOrderedBySteps:@"102=202"]){
            NSAssert([steps isOrderedBySteps:@"102=103=202=203"], @"按照顺序执行");
        }
        else{
            NSAssert([steps isOrderedBySteps:@"202=203=102=103"], @"按照顺序执行");
        }
        waitSuccess;
    } delay:5];
    
    returnWait;
}

-(waiter)test_pthread_mutex_recursive{
    [logger reset];
    
    static pthread_mutex_t pLock;
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr); //初始化attr并且给它赋予默认
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE); //设置锁类型，这边是设置为递归锁
    pthread_mutex_init(&pLock, &attr);
    pthread_mutexattr_destroy(&attr); //销毁一个属性对象，在重新进行初始化之前该结构不能重新使用
    
    // INFO: 递归锁允许同一个线程在未释放其拥有的锁时反复对该锁进行加锁操作
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^RecursiveBlock)(int);
        RecursiveBlock = ^(int value) {
            pthread_mutex_lock(&pLock);
            if (value > 0) {
                [self->logger addStep:value];
                RecursiveBlock(value - 1);
            }
            pthread_mutex_unlock(&pLock);
        };
        RecursiveBlock(5);
    });
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"5=4=3=2=1"], @"按照顺序执行");
        waitSuccess;
    } delay:1];
    
    returnWait;
}

-(waiter)testNSLock{
    [logger reset];
    
    NSLock *lock = [NSLock new];
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self->logger addStep:1];
        sleep(4);//睡眠5秒
        [lock lock];
        [self->logger addStep:2];
        [lock unlock];
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self->logger addStep:3];
        BOOL x =  [lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:3]];
        if (x) {
            [self->logger addStep:4];
            [lock unlock];
        }
        else{
            [self->logger addStep:5];
        }
    });
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"3=4=2"], @"按照顺序执行");
        waitSuccess;
    } delay:5];
    
    returnWait;
}

-(waiter)testNSCondition{
    [logger reset];
    
    NSCondition *cLock = [NSCondition new];
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // INFO: NSCondition执行lock不阻塞、需要wait执行阻塞
        [cLock lock];
        [self->logger addStep:101];
        [cLock wait];
        [self->logger addStep:102];
        [cLock unlock];
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lock];
        [self->logger addStep:201];
        [cLock wait];
        [self->logger addStep:202];
        [cLock unlock];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        [self->logger addStep:301];
        // INFO: 唤醒一个等待线程
        [cLock signal];
    });
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"301=102"] || [steps isOrderedBySteps:@"301=202"], @"按照顺序执行");
        waitSuccess;
    } delay:3];
    
    returnWait;
}

-(waiter)testNSCondition2{
    [logger reset];
    
    NSCondition *cLock = [NSCondition new];
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lock];
        [self->logger addStep:101];
        [cLock wait];
        [self->logger addStep:102];
        [cLock unlock];
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lock];
        [self->logger addStep:201];
        [cLock wait];
        [self->logger addStep:202];
        [cLock unlock];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
        [self->logger addStep:301];
        // INFO: 唤醒所有等待的线程
        [cLock broadcast];
    });
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"301=102=202"] || [steps isOrderedBySteps:@"301=202=102"], @"按照顺序执行");
        waitSuccess;
    } delay:3];
    
    returnWait;
}

-(waiter)testNSRecursiveLock{
    [logger reset];
    
    NSRecursiveLock *rLock = [NSRecursiveLock new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^RecursiveBlock)(int);
        RecursiveBlock = ^(int value) {
            [rLock lock];
            if (value > 0) {
                [self->logger addStep:value];
                RecursiveBlock(value - 1);
            }
            [rLock unlock];
        };
        RecursiveBlock(4);
    });
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"4=3=2=1"], @"按照顺序执行");
        waitSuccess;
    } delay:1];
    
    returnWait;
}

-(waiter)testNSConditionLock{
    [logger reset];
    
    NSConditionLock *cLock = [[NSConditionLock alloc] initWithCondition:0];
    
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([cLock tryLockWhenCondition:0]){
            [self->logger addStep:1];
            [cLock unlockWithCondition:1];
        }else{
            [self->logger addStep:2];
        }
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lockWhenCondition:3];
        [self->logger addStep:3];
        [cLock unlockWithCondition:2];
    });
    
    //线程3
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lockWhenCondition:1];
        [self->logger addStep:4];
        [cLock unlockWithCondition:3];
    });
    
    [logger check:^(NSArray *steps){
        NSAssert([steps isOrderedBySteps:@"1=4=3"], @"按照顺序执行");
        waitSuccess;
    } delay:1];
    
    returnWait;
}

-(void)testSynchronized1{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:0];
    
    static void (^RecursiveBlock)(NSArray *);
    RecursiveBlock = ^(NSArray *mutArray) {
        @synchronized(mutArray) {
            for (int i = 0;i< mutArray.count ; i++) {
                if ([mutArray[i] isKindOfClass:[NSArray class]]) {
                    RecursiveBlock(mutArray[i]);
                }else{
                    NSLog(@">>> %@",mutArray[i]);
                    [tmpArray addObject:mutArray[i]];
                }
            }
        }
    };
    RecursiveBlock(@[@[@[@[@[@[@[@[@[@4,@5,@6],@5,@6],@5,@6],@5,@6],@5,@6]]]]]);
    
    [logger check:^(NSArray *steps){
        // INFO: 同步锁的嵌套使用而不会出现死锁
        waitSuccess;
    } delay:0];
}


-(void)testSynchronizedArray1{
    static NSString *token = @"synchronized-token";
    __block NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < 1000; i ++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            @synchronized (token) {
                [array addObject:@(i)];
            }
        });
    }
    NSAssert(array.count != 1000, @"顺利执行");
}

-(void)testSynchronizedArray2{
    __block NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < 1000; i ++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            @synchronized (array) {
                [array addObject:@(i)];
            }
        });
    }
    // QUIZ: 为什么呀
    NSAssert(array.count != 1000, @"顺利执行");
}

-(void)testSynchronizedArray3{
    __block NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < 1000; i ++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // INFO: 多线程对array的操作却是频繁的创建和release，当某个瞬间arry执行了release的时候就 @synchronized(nil) ，上文已经分析了这个时候do nothing，所以不能起到同步锁的作用
            @synchronized (array) {
                waitFail;
                SafeExit();
                array = [NSMutableArray array];
            }
        });
    }
}

@end
