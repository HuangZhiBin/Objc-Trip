//
//  DeallocViewController.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/8.
//

#import "DeallocViewController.h"
#import "TimerViewController.h"

@interface DeallocViewController ()

@end

@implementation DeallocViewController

-(NSDictionary*)redirect{
    return @{
        @"testTimer_": @[ @"TimerViewController", @"testTimer" ],
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.TimerViewController
}

-(void)testTimer_{
    TimerViewController *vc = [[TimerViewController alloc] init];
    vc.checkDellocCallback = ^(BOOL isDealloc){
        NSAssert(!isDealloc, @"内存泄漏");
    };
    vc.testcase = @"testTimer";
    [self.navigationController pushViewController:vc animated:YES];
     
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)dealloc{
    NSLog(@"dealloc");
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
