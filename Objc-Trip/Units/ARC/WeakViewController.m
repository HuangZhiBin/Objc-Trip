//
//  WeakViewController.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/8.
//

#import "WeakViewController.h"
#import "WeakTestViewController.h"
#import "WeakStrTestViewController.h"

static NSString * const TAG = @"abc";

@interface WeakViewController ()
@property (nonatomic, weak) NSString *weakStr;
@end

@implementation WeakViewController{
    NSInteger testcase;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(NSDictionary*)redirect{
    return @{
        @"testString1": @[ @"WeakStrTestViewController", @"testString1" ],
        @"testString2": @[ @"WeakStrTestViewController", @"testString2" ],
        @"testString3": @[ @"WeakStrTestViewController", @"testString3" ],
        @"testArray1": @[ @"WeakTestViewController", @"testArray1" ],
        @"testArray2": @[ @"WeakTestViewController", @"testArray2" ],
        @"testArray3": @[ @"WeakTestViewController", @"testArray3" ],
    };
}

-(void)groupNSString{}

-(void)testString1{
    WeakStrTestViewController *vc = [[WeakStrTestViewController alloc] init];
    vc.testcase = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)testString2{
    WeakStrTestViewController *vc = [[WeakStrTestViewController alloc] init];
    vc.testcase = 2;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)testString3{
    WeakStrTestViewController *vc = [[WeakStrTestViewController alloc] init];
    vc.testcase = 3;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)groupArray{}

-(void)testArray1{
    WeakTestViewController *vc = [[WeakTestViewController alloc] init];
    vc.testcase = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)testArray2{
    WeakTestViewController *vc = [[WeakTestViewController alloc] init];
    vc.testcase = 2;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)testArray3{
    WeakTestViewController *vc = [[WeakTestViewController alloc] init];
    vc.testcase = 3;
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