//
//  DeallocViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/15.
//

#import "DeallocController.h"

@interface DeallocController ()

@end

@implementation DeallocController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSAssert(self.checkDellocCallback, @"未定义deallo回调");
    
    [BaseUtil checkVcDelloc:getAddr(self) result:self.checkDellocCallback];
}

-(void)dealloc{
    [BaseUtil sendDealloc:getAddr(self)];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    NSString *addr = [NSString stringWithString:getAddr(self)];
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [BaseUtil lastCheckDealloc:addr];
        [timer invalidate];
    }];
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
