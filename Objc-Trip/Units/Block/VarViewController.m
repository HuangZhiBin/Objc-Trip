//
//  VarViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/14.
//

#import "VarViewController.h"
#import "BlockArrayViewController.h"

@interface VarViewController ()

@end

@implementation VarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(NSDictionary *)redirect{
    return @{
        @"testMutableArray2": @[ @"BlockArrayViewController", @"test" ],
    };
}

-(void)testStaticVar{
    static int val = 1;
    void (^blk)(void) = ^{
        NSAssert(val == 2, @"val的值为2");
        val = 3;
    };
    val = 2;
    blk();
    NSAssert(val == 3, @"val的值为3");
}

-(void)groupInt{}

-(void)testCaptureInt{
    int val = 1;
    void (^blk)(void) = ^{
        // INFO: block对于自动变量是值拷贝
        NSAssert(val == 1, @"捕获的值为瞬间值");
    };
    val = 2;
    blk();
}

-(void)testResetVal{
    int val = 1;
    void (^blk)(void) = ^{
        SafeExit();
        // INFO: 下面的代码会编译错误
        // val = 2;
    };
    
    blk();
}

-(void)test__block1{
    __block int val = 1;
    void (^blk)(void) = ^{
        NSAssert(val == 2, @"捕获的值为最新值");
    };
    val = 2;
    blk();
}

-(void)test__block2{
    __block int val = 1;
    void (^blk)(void) = ^{
        val = 2;
    };
    blk();
    NSAssert(val == 2, @"捕获的值为最新值");
}

-(void)groupNSString{}

-(void)testCaptureString{
    NSString *str = @"hello";
    void (^blk)(void) = ^{
        // INFO: block对于OC类型的自动变量是指针拷贝
        NSAssert([str isEqualToString:@"hello"], @"捕获的值为瞬间值");
    };
    str = @"it's me";
    blk();
}

-(void)testCaptureString2{
    NSString *str = [NSString stringWithFormat:@"%@", @"hello_hello"];
    void (^blk)(void) = ^{
        NSAssert([str isEqualToString:@"hello_hello"], @"捕获的值为瞬间值");
    };
    str = [NSString stringWithFormat:@"%@", @"hello_hello_2"];
    blk();
}

-(void)groupNSArray{}

-(void)testMutableArray{
    NSMutableArray *arr = [NSMutableArray array];
    void (^blk)(void) = ^{
        NSAssert(arr.count == 1, @"数组长度为1");
        [arr addObject:[NSObject new]];
    };
    [arr addObject:[NSObject new]];
    blk();
    NSAssert(arr.count == 2, @"数组长度为2");
}

-(void)testMutableArray2{
    BlockArrayViewController *vc = [[BlockArrayViewController alloc] init];
    vc.testcase = @"test";
    vc.autoPop = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)groupStrongWeak{}

-(void)test__strong{
    typedef int (^blk_t)(id);
    
    blk_t blk;
    
    {
        id array = [[NSMutableArray alloc] init];
        blk = ^(id obj){
            [array addObject:obj];
            return (int)[array count];
        };
    }
    
    NSAssert(blk([NSObject new]) == 1, @"array元素加1");
    NSAssert(blk([NSObject new]) == 2, @"array元素加1");
    NSAssert(blk([NSObject new]) == 3, @"array元素加1");
}

-(void)test__weak{
    typedef int (^blk_t)(id);
    
    blk_t blk;
    
    {
        id array = [[NSMutableArray alloc] init];
        __weak id array2 = array;
        blk = ^(id obj){
            [array2 addObject:obj];
            return (int)[array2 count];
        };
    }
    
    NSAssert(blk([NSObject new]) == 0, @"array为空数组");
    NSAssert(blk([NSObject new]) == 0, @"array为空数组");
    NSAssert(blk([NSObject new]) == 0, @"array为空数组");
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
