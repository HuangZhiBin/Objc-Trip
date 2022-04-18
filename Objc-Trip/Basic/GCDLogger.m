//
//  GCDLogger.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/16.
//

#import "GCDLogger.h"
#import "NSArray+GCD.h"

void stepLog(NSMutableArray *arr, NSInteger val) {
    [arr addObject:[NSNumber numberWithInteger:val]];
}

@implementation GCDLogger{
    NSMutableArray *steps;
    dispatch_semaphore_t sem;
}

-(void)reset{
    steps = [NSMutableArray array];
    sem = dispatch_semaphore_create(1);
}

-(void)addStep:(NSInteger)step{
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    stepLog(steps, step);
    dispatch_semaphore_signal(sem);
}

-(void)check:(GCDCallback)callback delay:(NSTimeInterval)interval{
    __weak NSArray *weakArr = steps;
    [NSTimer scheduledTimerWithTimeInterval:interval repeats:NO block:^(NSTimer * _Nonnull timer) {
        callback(weakArr);
        [timer invalidate];
    }];
}

@end
