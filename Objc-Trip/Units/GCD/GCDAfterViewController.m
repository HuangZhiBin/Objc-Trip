//
//  GCDAfterViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/16.
//

#import "GCDAfterViewController.h"
#import "GCDLogger.h"

@interface GCDAfterViewController ()

@end

@implementation GCDAfterViewController{
    GCDLogger *logger;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    logger = [[GCDLogger alloc] init];
}

-(wait)testAfter{
    [logger reset];
    
    // INFO: 不是在指定时间后执行处理，而只是在指定时间追加处理到dispatch_queue
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self->logger addStep:1];
    });
    
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert(steps.count > 0, @"dispatch_after已执行");
        waitSuccess;
    } delay:2];
    
    returnWait;
}

// INFO:当您的计算机进入睡眠状态时，dispatch_time 停止运行。 dispatch_walltime 继续运行。 因此，如果您想在一小时分钟内执行一项操作，但 5 分钟后您的计算机进入睡眠状态 50 分钟，则 dispatch_walltime 将在一个小时后执行，即计算机唤醒后 5 分钟。 dispatch_time 将在计算机运行一个小时后执行，即唤醒后 55 分钟。

-(wait)test_dispatch_time{
    [logger reset];
    
    // INFO: dispatch_time是相对时间
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self->logger addStep:1];
    });
    
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert(steps.count > 0, @"dispatch_after已执行");
        waitSuccess;
    } delay:2];
    
    returnWait;
}

-(wait)test_dispatch_walltime{
    [logger reset];
    
    // INFO: dispatch_time是绝对时间
    dispatch_time_t time = dispatch_walltime(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self->logger addStep:1];
    });
    
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert(steps.count > 0, @"dispatch_after已执行");
        waitSuccess;
    } delay:2];
    
    returnWait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
