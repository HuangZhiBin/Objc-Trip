//
//  BaseUtil.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/7.
//

#import "BaseUtil.h"
#import <UIKit/UIKit.h>

static NSMutableString *lastLog;
static NSMutableDictionary *vcDealloc;

NSString* getAddr(id obj) {
    return [NSString stringWithFormat:@"%p", obj];
}

@implementation BaseUtil

+(void)startListeningAutoRelease{
    NSPipe * pipe = [NSPipe pipe];
    NSFileHandle *pipeReadHandle = [pipe fileHandleForReading];
    dup2([[pipe fileHandleForWriting] fileDescriptor], STDERR_FILENO);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redirectNotificationHandle:) name:NSFileHandleReadCompletionNotification object:pipeReadHandle];
    [pipeReadHandle readInBackgroundAndNotify];
}

+(void)stopListeningAutoRelease{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    lastLog = nil;
}

+(void)checkAutoRelease:(NSString *)objAdrr result:(CheckAutoReleaseCallback)callback{
    if(!lastLog){
        lastLog = [NSMutableString string];
    }
    
    NSString *key = [NSString stringWithFormat:@">>%@<<",[self uuidString]];
    PrintAutoReleasePool();
//    _objc_autoreleasePoolPrint();
    NSLog(@"%@",key);
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if(!lastLog || ![lastLog containsString:key]){
            return;
        }
        
        NSInteger endIdx = [lastLog rangeOfString:key].location;
        NSString *log = [lastLog substringToIndex:endIdx];
        NSInteger lastBegin = [log rangeOfString:@"AUTORELEASE POOLS for thread" options:NSBackwardsSearch].location;
        log = [log substringFromIndex:lastBegin];
        callback([self containsObj:objAdrr log:log]);
        [timer invalidate];
    }];
}

+(BOOL)containsObj:(NSString *)objAdrr log:(NSString*)log{
    return [log containsString:[NSString stringWithFormat:@"  %@  ", objAdrr]];
}

//获取当前时间戳
+  (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

//uuid  消息的唯一标识
+ (NSString *)uuidString{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}

+ (void)redirectNotificationHandle:(NSNotification *)nf{
    NSData *data = [[nf userInfo] objectForKey:NSFileHandleNotificationDataItem];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [[nf object] readInBackgroundAndNotify];
    if([str containsString:@"AUTORELEASE POOLS for thread"]){
        [lastLog appendString:str];
    }
}

+(void)checkVcDelloc:(NSString *)vcAddr result:(CheckDellocCallback)result{
    if(!vcDealloc){
        vcDealloc = [NSMutableDictionary dictionary];
    }
    
    vcDealloc[vcAddr] = result;
}

+(void)sendDealloc:(NSString *)vcAddr{
    if(![vcDealloc.allKeys containsObject:vcAddr]){
        return;
    }
    CheckDellocCallback result = vcDealloc[vcAddr];
    result(YES);
    [vcDealloc removeObjectForKey:vcAddr];
}

+(void)lastCheckDealloc:(NSString *)vcAddr{
    if(![vcDealloc.allKeys containsObject:vcAddr]){
        return;
    }
    CheckDellocCallback result = vcDealloc[vcAddr];
    result(NO);
    [vcDealloc removeObjectForKey:vcAddr];
}

+(NSArray*)arrayWithLength:(int)length{
    NSMutableArray *iosArray = [NSMutableArray array];
    for(int i = 0; i < 1000000; i++){
        [iosArray addObject:@(i)];
    }
    return [iosArray copy];
}

@end
