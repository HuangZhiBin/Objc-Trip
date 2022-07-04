//
//  BlockStructViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/26.
//

#import "BlockStructViewController.h"

@interface BlockStructViewController ()

@property (nonatomic, copy) NSString *name;

@end

@implementation BlockStructViewController{
    int _age;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

int val1 = 0;
static int val2 = 0;

-(void)testStruct{
    int val_1 = 0;
    static int val_2 = 0;
    void(^blk)(int, int) = ^(int a, int b){
        NSLog(@"val1=%d,val2=%d,val_1=%d,val_2=%d", val1, val2, val_1, val_2);
        NSLog(@"a=%d,b=%d", a, b);
    };
    
    struct __main_block_impl_0 *blockStruct = (__bridge struct __main_block_impl_0 *)blk;
    // INFO: 在执行block的时候有可能自动变量已经被销毁了，那么此时如果再去访问被销毁的地址肯定会发生坏内存访问，因此对于自动变量一定是值传递而不可能是指针传递了
    NSAssert(@"blockStruct->val_1", @"捕获自动变量val_1，类型为int，值拷贝");
    NSAssert(@"blockStruct->val_2", @"捕获自动变量val_2，类型为int*，指针拷贝");
    
    NSAssert(@"blockStruct->val1 == false", @"不捕获全局变量");
    NSAssert(@"blockStruct->val2 == false", @"不捕获全局静态变量");
    
    NSAssert(@"blockStruct->impl->isa", @"证明是OC对象，isa指向类对象");
    NSAssert(@"blockStruct->impl->FuncPtr", @"代码块地址");
    
    NSAssert(@"blockStruct->Desc->Block_size", @"block占用的内存大小");
}

-(void)testStruct2{
    
    void(^blk)(int, int) = ^(int a, int b){
        NSLog(@"name=%@", self.name);
        NSLog(@"age=%d", _age);
    };
    
    struct __main_block_impl_0 *blockStruct = (__bridge struct __main_block_impl_0 *)blk;
    // INFO: block中使用的是实例对象self的属性，block中捕获的仍然是self，并通过self去获取使用到的属性
    NSAssert(@"blockStruct->self->name", @"");
    NSAssert(@"blockStruct->self->age", @"");
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
