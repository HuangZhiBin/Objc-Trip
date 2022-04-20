//
//  TimerViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/15.
//

#import "TimerViewController.h"
#import "NSTimer+Block.h"

@interface TimerViewController ()
@end

@implementation TimerViewController{
    NSTimer *_timer;
    NSString *_str;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _str = @"xxx";
    [self performSelector:NSSelectorFromString(self.testcase)];
}

-(void)testScheduledLeak1{
    // INFO: scheduledTimer的block使用了self导致内存泄漏
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"%@",_str);
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)testScheduledLeak2{
    // INFO: scheduledTimer的block不使用self，内存不泄漏
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"%@", @"Hello");
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)testTimerWithLeak1{
    // INFO: 内存泄漏
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(logInfo) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)testTimerWithLeak2{
    // INFO: repeat为NO，内存不泄漏
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(logInfo) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    
    __weak TimerViewController *vc = self;
    [NSTimer scheduledTimerWithTimeInterval:2 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [vc.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)testTimerWithLeak3{
    // INFO: 内存不泄漏
    _timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"%@", @"Hello");
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)testTimerWithLeak4{
    // INFO: 内存泄漏
    _timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"%@",_str);
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)testSolveLeak{
    _timer = [NSTimer b_timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"%@", @"Hello");
    }];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    [_timer invalidate];
    _timer = nil;
}

-(void)logInfo{
    NSLog(@"%@",_str);
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
