//
//  MsgSendViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/24.
//

#import "MsgSendViewController.h"
#import "ResolveInstanceMethodViewController.h"
#import "ForwardTargetViewController.h"
#import "ForwardInvocationViewController.h"

@interface MsgSendViewController ()

@end

@implementation MsgSendViewController

- (NSDictionary *)redirect{
    return @{
        @"testResolveInstanceMethod": @[@"ResolveInstanceMethodViewController",@"test",],
        @"testForwardTarget": @[@"ForwardTargetViewController",@"test",],
        @"testForwardInvocation": @[@"ForwardInvocationViewController",@"test",],
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)testResolveInstanceMethod{
    ResolveInstanceMethodViewController *vc = [[ResolveInstanceMethodViewController alloc] init];
    vc.testcase = @"test";
    vc.autoPop = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)testForwardTarget{
    ForwardTargetViewController *vc = [[ForwardTargetViewController alloc] init];
    vc.testcase = @"test";
    vc.autoPop = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)testForwardInvocation{
    ForwardInvocationViewController *vc = [[ForwardInvocationViewController alloc] init];
    vc.testcase = @"test";
    vc.autoPop = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
