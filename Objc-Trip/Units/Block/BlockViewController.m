//
//  BlockViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/14.
//

#import "BlockViewController.h"



@interface BlockViewController ()

@end

@implementation BlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)groupGlobal{}

-(void)testGlobal1{
    void (^blk)(void) = ^{
        int num = 123;
        printf("global %d", num);
    };
    NSAssert([NSStringFromClass([blk class]) isEqual:@"__NSGlobalBlock__"], @"类型为全局block");
}

-(void)testGlobal2{
    void (^blk)(int) = ^(int y){
        printf("stack %d", y);
    };
    int num = 124;
    blk(num);
    NSAssert([NSStringFromClass([blk class]) isEqual:@"__NSGlobalBlock__"], @"类型为全局block");
}

-(void)testGlobal3{
    int (^blk)(int) = ^(int num){
        printf("stack %d", num);
        return num + 1;
    };
    int num = 10;
    int num2 = blk(num);
    NSAssert([NSStringFromClass([blk class]) isEqual:@"__NSGlobalBlock__"], @"类型为全局block");
    NSAssert(num2 == 11, @"值加1");
}

-(void)groupStack{}

-(void)testStack{
    int num = 123;
    NSString *className = NSStringFromClass([^(){printf("%d", num);} class]);
    NSAssert([className isEqual:@"__NSStackBlock__"], @"类型为栈block");
}

-(void)groupMalloc{}

-(void)testMalloc1{
    int num = 123;
    // INFO: block赋值给strong修饰符的id，编译器自动复制block到堆上
    void (^blk)(void) = ^(){
        printf("%d", num);
    };
    NSAssert([NSStringFromClass([blk class]) isEqual:@"__NSMallocBlock__"], @"类型为堆block");
}

-(void)testMalloc2{
    __block int num = 123;
    void (^blk)(void) = ^(){
        num = num + 1;
    };
    NSAssert([NSStringFromClass([blk class]) isEqual:@"__NSMallocBlock__"], @"类型为堆block");
}

-(void)groupCopy{}

-(void)testCopyGlobal{
    void (^blk)(void) = ^{
        int num = 123;
        printf("global %d", num);
    };
    id blk2 = [blk copy];
    NSAssert([NSStringFromClass([blk2 class]) isEqual:@"__NSGlobalBlock__"], @"copy global为block");
}

-(void)testCopyStack{
    int num = 123;
    NSString *className = NSStringFromClass([[^(){printf("%d", num);} copy] class]);
    NSAssert([className isEqual:@"__NSMallocBlock__"], @"copy block为malloc");
}

-(void)testCopyMalloc{
    int num = 123;
    void (^blk)(void) = ^(){
        printf("%d", num);
    };
    id blk2 = [blk copy];
    NSAssert([NSStringFromClass([blk2 class]) isEqual:@"__NSMallocBlock__"], @"copy malloc为malloc");
    NSAssert([getAddr(blk) isEqual:getAddr(blk2)], @"浅拷贝");
    NSAssert(RetainCount(blk2) == 1, @"引用计数=1");
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
