//
//  OthersViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/15.
//

#import "OthersViewController.h"
#import "ClassViewController.h"
#import "Son.h"

@interface OthersViewController ()

@end

@implementation OthersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(NSDictionary*)redirect{
    return @{
        @"testSon": @[ @"Son", @"testSon" ],
        @"testClassMethod": @[ @"ClassViewController", @"test" ],
    };
}

-(void)testSon{
    [[Son alloc] init];
}

-(void)testRuntimeType{
    NSString *obj = [[NSData alloc] init];
    // INFO: 编译时类型为NSString
    NSAssert([obj isKindOfClass:[NSData class]], @"obj运行时的类型为NSData");
}

-(void)testClassMethod{
    ClassViewController *vc = [[ClassViewController alloc] init];
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
