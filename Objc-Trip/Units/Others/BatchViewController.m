//
//  AtomicViewController.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/8.
//

#import "BatchViewController.h"

@interface BatchViewController ()

@property (atomic, assign) NSInteger num;
@property (atomic, strong) NSMutableArray *nums;
@property (nonatomic, copy) NSString *str;

@end

@implementation BatchViewController{
    NSString *_str;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)testAddIntManyTimes{
    self.num = 0;
    
    for(NSInteger idx = 1; idx <= 10000; idx++){
        dispatch_async(dispatch_get_global_queue(0, 0) , ^{
            self.num += 1;
        });
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
        NSAssert(self.num < 10000, @"所有步骤都执行了");
        [timer invalidate];
    }];
}

-(void)testAddItemManyTimes🔥{
    self.nums = [@[] mutableCopy];
    
    for(NSInteger idx = 1; idx <= 10000; idx++){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.nums addObject:@(idx)];
        });
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
        NSAssert(self.nums.count < 10000, @"所有步骤都执行了");
        [timer invalidate];
    }];
}

-(void)testAddInt{
    __block int a = 0;
    while (a < 5) {
        dispatch_async(dispatch_get_global_queue(0,0),^{
            a++;
        });
    }
    NSAssert(a > 5, @"和大于5");
}

-(void)testString🔥{
    for(NSInteger idx = 1; idx <= 10000; idx++){
      dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.str = [NSString stringWithFormat:@"Hello_%ld", idx];
      });
    }
    NSAssert(true, @"可以成功执行");
}

-(void)testString2{
    for(NSInteger idx = 1; idx <= 10000; idx++){
      dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.str = @"sdfsdfsdf";
      });
    }
    NSAssert(true, @"可以成功执行");
}

-(void)testString3🔥{
    for(NSInteger idx = 1; idx <= 10000; idx++){
      dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _str = [NSString stringWithFormat:@"Hello_%ld", idx];
      });
    }
    NSAssert(true, @"可以成功执行");
}

@end
