//
//  AppDelegate.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/7.
//

#import "AppDelegate.h"
#import "BaseUtil.h"
#import <SSZipArchive/SSZipArchive.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [UIWindow new];
    [_window makeKeyWindow];
    
    NSString *zipPath = [[NSBundle mainBundle] pathForResource:@"codes" ofType:@"zip"];
    BOOL zipExisted = [[NSFileManager defaultManager] fileExistsAtPath:zipPath];
    NSAssert(zipExisted, @"代码源文件zip不存在");
//    NSString *codesPath = [[NSBundle mainBundle] bundlePath];
    
    // Document路径
    NSString *codesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //解压
    BOOL isSuccess = [SSZipArchive unzipFileAtPath:zipPath toDestination:codesPath];
    NSAssert(isSuccess, @"代码解压失败");
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
