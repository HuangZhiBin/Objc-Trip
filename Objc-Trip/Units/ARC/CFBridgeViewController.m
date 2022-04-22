//
//  ArcViewController.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/8.
//

#import "CFBridgeViewController.h"
#import "BridgeLeakViewController.h"

@interface CFBridgeViewController ()

@end

@implementation CFBridgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)group__bridge{}

-(void)test__bridge_void_N__bridge_id{
    NSObject *obj = [NSObject alloc];
    
    // INFO: __bridge void*不持有对象
    void *p = (__bridge void*)obj;
    NSAssert(RetainCount(obj) == 1, @"__bridge void*，p不持有对象，引用计数==1");
    NSAssert(CFGetRetainCount(p) == 1, @"__bridge void*，p不持有对象，引用计数==1");
    
    // INFO:__bridge id持有对象
    id obj2 = (__bridge id)p;
    NSAssert(RetainCount(obj) == 2, @"__bridge id, obj2持有对象，引用计数==2");
    NSAssert(RetainCount(obj2) == 2, @"引用计数==2");
    NSAssert(CFGetRetainCount(p) == 2, @"引用计数==2");
}

-(void)test__bridge_retained_N__bridge_transfer{
    NSObject *obj = [NSObject alloc];
    // INFO: __bridge_retained持有
    void *p = (__bridge_retained void*)obj;
    NSAssert(RetainCount(obj) == 2, @"__bridge_retained，p持有对象，引用计数==2");
    NSAssert(CFGetRetainCount(p) == 2, @"__bridge_retained，p持有对象，引用计数==2");
    
    // INFO: __bridge_transfer转移持有
    (void)(__bridge_transfer id)p;
    NSAssert(RetainCount(obj) == 1, @"__bridge_transfer id, 引用计数==1");
    NSAssert(CFGetRetainCount(p) == 1, @"引用计数==1");
}

-(void)groupCFBridging{}

-(void)testCFBridgingRetain{
    id obj = [NSMutableArray array];
    // CFBridgingRetain 等同于 __bridge_retained
    CFMutableArrayRef cfArr = (CFMutableArrayRef)CFBridgingRetain(obj);
    NSAssert(CFGetRetainCount(cfArr) == 2, @"引用计数==2");
    NSAssert(RetainCount(obj) == 2, @"引用计数==2");
}

-(void)testCFBridgingRelease{
    CFMutableArrayRef cfArr = CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
    // CFBridgingRelease 等同于 __bridge_transfer
    id obj = CFBridgingRelease(cfArr);
    NSAssert(CFGetRetainCount(cfArr) == 1, @"引用计数==1");
    NSAssert(RetainCount(obj) == 1, @"引用计数==1");
}

-(void)groupZone{}

-(void)testBridgeLoop{
    CFMutableArrayRef cfArr = NULL;
    {
        id obj = [NSMutableArray array];
        cfArr = (CFMutableArrayRef)CFBridgingRetain(obj);
        NSAssert(CFGetRetainCount(cfArr) == 2, @"cfArr持有对象，引用计数==2");
        NSAssert(RetainCount(obj) == 2, @"obj引用计数==2");
    }
    NSAssert(CFGetRetainCount(cfArr) == 1, @"cfArr持有对象，引用计数==1");
}

-(void)testBridgeLoop2_0{
    CFMutableArrayRef cfArr = NULL;
    {
        id obj = [NSMutableArray array];
        // 下面等同于__bridge void*
        cfArr = (__bridge CFMutableArrayRef)obj;
        NSAssert(CFGetRetainCount(cfArr) == 1, @"cfArr不持有对象，引用计数==1");
        NSAssert(RetainCount(obj) == 1, @"obj引用计数==1");
    }
    
    SafeExit();
    // INFO: cfArr不持有对象，cfArr已释放
    CFShow(cfArr);
}

-(void)groupLeak{}


-(NSDictionary*)redirect{
    return @{
        @"testLeak_": @[ @"BridgeLeakViewController", @"testLeak" ],
        @"testNonLeak_": @[ @"BridgeLeakViewController", @"testNonLeak" ],
    };
}

-(void)testLeak_{
    BridgeLeakViewController *vc = [[BridgeLeakViewController alloc] init];
    vc.testcase = @"testLeak";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)testNonLeak_{
    BridgeLeakViewController *vc = [[BridgeLeakViewController alloc] init];
    vc.testcase = @"testNonLeak";
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
