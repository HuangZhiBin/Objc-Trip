//
//  BaseUtil.h
//  Objc-Journey
//
//  Created by binhuang on 2022/4/7.
//

#import <Foundation/Foundation.h>
#import "DebuggerView.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^CheckDellocCallback)(BOOL);

typedef void(^CheckAutoReleaseCallback) (BOOL);

// 引入打印函数
extern void _objc_autoreleasePoolPrint(void);
extern NSString* getAddr(id obj);

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

#define RetainCount(obj) CFGetRetainCount((__bridge CFTypeRef)(obj))
#define PrintAutoReleasePool() _objc_autoreleasePoolPrint();

#define SafeExit() return;
#define SafeExit(obj) return obj;

#define waiter int
#define returnWait return 0;
#define waitSuccess [DebuggerView sendExecResult:YES];
#define waitFail [DebuggerView sendExecResult:NO];

@interface BaseUtil : NSObject

+(void)checkAutoRelease:(NSString *)objAdrr result:(CheckAutoReleaseCallback)callback;
+(void)startListeningAutoRelease;
+(void)stopListeningAutoRelease;

+(void)checkVcDelloc:(NSString*)vcAddr result:(CheckDellocCallback)result;
+(void)sendDealloc:(NSString*)vcAddr;
+(void)lastCheckDealloc:(NSString*)vcAddr;
+(NSArray*)arrayWithLength:(int)length;
@end

NS_ASSUME_NONNULL_END
