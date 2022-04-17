//
//  BlockLeakViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/15.
//

#import "BlockLeakViewController.h"
#import "BlockLeakTestViewController.h"

@interface BlockLeakViewController ()

@end

@implementation BlockLeakViewController

-(NSDictionary*)redirect{
    return @{
        @"testLoopRetain_": @[ @"BlockLeakTestViewController", @"testLoopRetain" ],
        @"test__weak_": @[ @"BlockLeakTestViewController", @"test__weak" ],
        @"test__block_": @[ @"BlockLeakTestViewController", @"test__block" ],
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)testLoopRetain_{
    BlockLeakTestViewController *vc = [[BlockLeakTestViewController alloc] init];
    vc.checkDellocCallback = ^(BOOL isDealloc){
        NSAssert(!isDealloc, @"内存泄漏");
    };
    vc.testcase = @"testLoopRetain";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)test__weak_{
    BlockLeakTestViewController *vc = [[BlockLeakTestViewController alloc] init];
    vc.checkDellocCallback = ^(BOOL isDealloc){
        NSAssert(isDealloc, @"内存未泄漏");
    };
    vc.testcase = @"test__weak";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)test__block_{
    BlockLeakTestViewController *vc = [[BlockLeakTestViewController alloc] init];
    vc.checkDellocCallback = ^(BOOL isDealloc){
        NSAssert(isDealloc, @"内存未泄漏");
    };
    vc.testcase = @"test__block";
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
