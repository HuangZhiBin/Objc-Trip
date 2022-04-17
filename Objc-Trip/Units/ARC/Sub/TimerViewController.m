//
//  TimerViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/15.
//

#import "TimerViewController.h"

@interface TimerViewController ()
@property (nonatomic, strong) NSString * str;
@end

@implementation TimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performSelector:NSSelectorFromString(self.testcase)];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)testTimer{
    self.str = @"xxx";
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"%@",self.str);
    }];
    // INFO: 内存泄漏
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
