//
//  TestModel.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/22.
//

#import "TestModel.h"
// INFO: extern可以访问全局变量
NSInteger age1 = 0;
// INFO: 把全局变量的作用域缩小到当前文件，保证外部类无法访问（即使在外部使用extern关键字也无法访问）
static NSInteger age2 = 0;
@implementation TestModel

@end
