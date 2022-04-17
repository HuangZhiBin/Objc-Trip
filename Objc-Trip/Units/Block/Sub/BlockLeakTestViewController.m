//
//  BlockLeakTestViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/15.
//

#import "BlockLeakTestViewController.h"
typedef int(^TestBlock) (void);
@interface BlockLeakTestViewController ()

@end

@implementation BlockLeakTestViewController{
    NSMutableArray *_array;
    TestBlock _blk;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self performSelector:NSSelectorFromString(self.testcase)];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)testLoopRetain{
    _array = [NSMutableArray arrayWithObject:@1];
    _blk = ^(){
        return [_array[0] intValue] + 1;
    };
    _blk();
    // INFO: 内存泄漏
}

-(void)test__weak{
    _array = [NSMutableArray arrayWithObject:@1];
    __weak NSMutableArray *weakArr = _array;
    _blk = ^(){
        return [weakArr[0] intValue] + 1;
    };
    _blk();
    // INFO: 内存未泄漏
}

-(void)test__block{
    _array = [NSMutableArray arrayWithObject:@1];
    __block NSMutableArray *blockArr = _array;
    _blk = ^(){
        int val =  [blockArr[0] intValue] + 1;
        blockArr = nil;
        return val;
    };
    _blk();
    // INFO: 内存未泄漏
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
