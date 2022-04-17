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
}

-(void)reset{
    steps = [NSMutableArray array];
}

-(void)addStep:(NSInteger)step{
    stepLog(steps, step);
}

-(void)check:(GCDCallback)callback delay:(NSTimeInterval)interval{
    __weak NSArray *weakArr = steps;
    [NSTimer scheduledTimerWithTimeInterval:interval repeats:NO block:^(NSTimer * _Nonnull timer) {
        callback(weakArr);
        [timer invalidate];
    }];
}

@end
