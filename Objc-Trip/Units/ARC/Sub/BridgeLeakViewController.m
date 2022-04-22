//
//  BridgeLeakViewController.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/8.
//

#import "BridgeLeakViewController.h"
#import "BaseUtil.h"
@interface BridgeLeakViewController ()

@end

@implementation BridgeLeakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)testLeak{
    CFMutableArrayRef cfArr = CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
    // 区别 __bridge_transfer
    id obj = (__bridge id)cfArr;
    NSAssert(CFGetRetainCount(cfArr) == 2, @"cfArr引用计数==2");
    NSAssert(RetainCount(obj) == 2, @"obj引用计数==2");
    
    // INFO: 超出作用域后，cfArr不会释放
}

-(void)testNonLeak{
    CFMutableArrayRef cfArr = CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
    // 区别 __bridge_transfer
    id obj = (__bridge_transfer id)cfArr;
    NSAssert(CFGetRetainCount(cfArr) == 1, @"cfArr引用计数==1");
    NSAssert(RetainCount(obj) == 1, @"obj引用计数==1");
    
    // INFO: 超出作用域后，cfArr会释放
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.navigationController popViewControllerAnimated:animated];
}

-(void)dealloc{
    NSLog(@"dealloc");
//    CFShow(cfArr);
//    NSAssert(YES, @"memory leaked!");
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
