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
static int dupValue;

NSString* getAddr(id obj) {
    return [NSString stringWithFormat:@"%p", obj];
}

NSString* getThreadName(NSThread *thread){
    return [NSString stringWithFormat:@"%@", thread];
}

BOOL isMainThread(NSString* threadName){
    return [threadName containsString:@"name = main"];
}

@implementation BaseUtil{
    
}

+(void)load{
    dupValue = dup(STDERR_FILENO);
}

+(void)startListeningAutoRelease{
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *pipeReadHandle = [pipe fileHandleForReading];
    dup2([[pipe fileHandleForWriting] fileDescriptor], STDERR_FILENO);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redirectNotificationHandle:) name:NSFileHandleReadCompletionNotification object:pipeReadHandle];
    [pipeReadHandle readInBackgroundAndNotify];
}

+(void)stopListeningAutoRelease{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    lastLog = nil;
    dup2(dupValue, STDERR_FILENO);
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

//?????????????????????
+  (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//??????????????????0???????????????
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 ?????????????????????????????????????????????
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

//uuid  ?????????????????????
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
