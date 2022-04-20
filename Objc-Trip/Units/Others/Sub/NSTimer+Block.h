//
//  MyTimer.h
//  Objc-Trip
//
//  Created by binhuang on 2022/4/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (Block)

+ (NSTimer *)b_timerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo block:(void (^)(NSTimer *timer))block;

@end

NS_ASSUME_NONNULL_END
