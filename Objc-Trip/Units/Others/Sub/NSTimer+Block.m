//
//  MyTimer.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/19.
//

#import "NSTimer+Block.h"

@interface NSTimer (Block)

@end

@implementation NSTimer (Block)

+ (NSTimer *)b_timerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo block:(void (^)(NSTimer *timer))block{
    NSTimer *_timer = [NSTimer timerWithTimeInterval:ti target:self selector:@selector(weak_blcokInvoke:) userInfo:[block copy] repeats:yesOrNo];
    return _timer;
}

+ (void)weak_blcokInvoke:(NSTimer *)timer {
    
    void (^block)(NSTimer *timer) = timer.userInfo;
    
    if (block) {
        block(timer);
    }
}
@end
