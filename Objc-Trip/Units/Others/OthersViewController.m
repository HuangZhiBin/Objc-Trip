//
//  OthersViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/15.
//

#import "OthersViewController.h"
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
