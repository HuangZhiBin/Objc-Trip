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
    BOOL isProcessing;
}

-(BOOL)shouldEnter{
    if(!isProcessing){
        steps = [NSMutableArray array];
    }
    return !isProcessing;
}

-(void)addStep:(NSInteger)step{
    stepLog(steps, step);
}

-(void)check:(GCDCallback)callback delay:(NSTimeInterval)interval{
    __weak NSArray *weakArr = steps;
    [NSTimer scheduledTimerWithTimeInterval:interval repeats:NO block:^(NSTimer * _Nonnull timer) {
        callback(weakArr);
        self->isProcessing = NO;
        [timer invalidate];
    }];
}

@end
