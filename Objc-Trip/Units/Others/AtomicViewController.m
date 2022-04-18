//
//  AtomicViewController.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/8.
//

#import "AtomicViewController.h"

@interface AtomicViewController ()

@property (atomic, assign) NSInteger num;
@property (atomic, strong) NSMutableArray *nums;

@end

@implementation AtomicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)testAdd100Times🔥{
    self.num = 0;
    
    for(NSInteger idx = 1; idx <= 100; idx++){
        dispatch_async(dispatch_get_global_queue(0, 0) , ^{
            self.num += 1;
        });
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
        NSAssert(self.num == 100, @"所有步骤都执行了");
        [timer invalidate];
    }];
}

-(void)testAdd100TimesForArray🔥{
    self.nums = [@[] mutableCopy];
    
    for(NSInteger idx = 1; idx <= 100; idx++){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.nums addObject:@(idx)];
        });
    }
    
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
        NSAssert(self.nums.count == 100, @"所有步骤都执行了");
        [timer invalidate];
    }];
}

@end
