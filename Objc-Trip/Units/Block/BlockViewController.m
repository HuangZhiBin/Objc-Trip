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
}

-(void)groupStack{}

-(void)testStack{
    int num = 123;
    NSString *className = NSStringFromClass([^(){printf("%d", num);} class]);
    // INFO: 使用自动变量但block不赋值给变量
    NSAssert([className isEqual:@"__NSStackBlock__"], @"类型为栈block");
}

-(void)groupMalloc{}

-(void)testMalloc1{
    int num = 123;
    // INFO: ARC在 block(1)函数返回值时;(2)block赋值给strong修饰符的id;(3)block作为函数参数，编译器自动复制block到堆上，以保存block
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
    NSAssert([NSStringFromClass([blk2 class]) isEqual:@"__NSGlobalBlock__"], @"copy global为global");
}

-(void)testCopyStack{
    int num = 123;
    NSString *className = NSStringFromClass([[^(){printf("%d", num);} copy] class]);
    NSAssert([className isEqual:@"__NSMallocBlock__"], @"copy stack为malloc");
}

-(void)testCopyMalloc{
    int num = 123;
    void (^blk)(void) = ^(){
        printf("%d", num);
    };
    id blk2 = [blk copy];
    NSAssert([NSStringFromClass([blk2 class]) isEqual:@"__NSMallocBlock__"], @"copy malloc为malloc");
    NSAssert([getAddr(blk) isEqual:getAddr(blk2)], @"浅拷贝");
    // INFO: 虽然 retainCount 始终是 1，但内存管理器中仍然会增加、减少计数，当引用计数为零的时候释放
    NSAssert(RetainCount(blk2) == 1, @"引用计数=1");
}

-(void)groupRetainCount{}

-(void)testRetainCount{
    NSObject *objc = [NSObject new];

    void(^block1)(void) = ^{
        // INFO: Block访问对象类型的auto变量时，由于block被自动copy到了堆区，从而对外部的对象进行强引用，如果这个对象同样强引用这个block，就会形成循环引用。
        long count = RetainCount(objc);
        NSAssert(count == 3, @"");
    };
    
    block1();
    
}

//-(void)testRetainCount{
//    NSObject *objc = [NSObject new];
//
//    long(^block1)(void) = ^{
//        return CFGetRetainCount((__bridge CFTypeRef)(objc));
//    };
//    NSAssert(block1() == 3, @"");
//
//    long(^__weak block2)(void) = ^{
//        return CFGetRetainCount((__bridge CFTypeRef)(objc));
//    };
//    NSAssert(block2() == 4, @"");
//
//    long(^block3)(void) = [block2 copy];
//    NSAssert(block3() == 5, @"");
//
//    __block NSObject *obj = [NSObject new];
//    long(^block4)(void) = ^{
//        return CFGetRetainCount((__bridge CFTypeRef)(obj));
//    };
//    NSAssert(block4() == 1, @"");
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
