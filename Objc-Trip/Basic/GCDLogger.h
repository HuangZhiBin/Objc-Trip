//
//  GCDLogger.h
//  Objc-Trip
//
//  Created by binhuang on 2022/4/16.
//

#import <Foundation/Foundation.h>
#import "NSArray+GCD.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^GCDCallback) (NSArray *steps);
extern void stepLog(NSMutableArray *arr, NSInteger val);
@interface GCDLogger : NSObject

-(void)reset;

-(void)addStep:(NSInteger)step;

-(void)check:(GCDCallback)callback delay:(NSTimeInterval)interval;

@end

NS_ASSUME_NONNULL_END
