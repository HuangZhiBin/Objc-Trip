//
//  StaticViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/22.
//

#import "StaticViewController.h"

@interface StaticViewController ()

@end

@implementation StaticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)testStatic1{
    // INFO: static关键字修饰局部变量时，只会初始化一次
    NSAssert([self addValue:1] == 1, @"初始化 +1");
    NSAssert([self addValue:1] == 2, @"不初始化 +1");
    
    [self addValue:0];
}

-(void)testExtern{
    /* TestModel.m
     NSInteger age1 = 0;
     */
    extern NSInteger age1;
    age1 += 10;
    // INFO: extern可以访问全局变量
    NSAssert(age1 == 10, @"+10");
    
    age1 = 0;
}

-(void)testExtern2{
    /* TestModel.m
     static NSInteger age1 = 0;
     */
    // INFO: static把全局变量的作用域缩小到当前文件，保证外部类无法访问
    // INFO: extern无法访问static变量
    // extern NSInteger age2;
}

- (int)addValue:(int)value {
    static int staticValue = 0;
    if(value != 0){
        staticValue += value;
    }
    else{
        staticValue = 0;
    }
    return staticValue;
}

@end
