//
//  LoadViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/25.
//

#import "LoadViewController.h"

static NSMutableArray *steps;

// DIVIDE

@interface People : NSObject

@end

@implementation People

+ (void)load{
    if(!steps){
        steps = [NSMutableArray array];
    }
    [steps addObject:@"People"];
}

@end

// DIVIDE

@interface Child : People

@end

@implementation Child

+ (void)load{
    if(!steps){
        steps = [NSMutableArray array];
    }
    [steps addObject:@"Child"];
}

@end

// DIVIDE

@interface Child (Ext)

@end

@implementation Child (Ext)

+ (void)load{
    if(!steps){
        steps = [NSMutableArray array];
    }
    [steps addObject:@"ChildExt"];
}

@end

// DIVIDE

@interface Child (Ext2)

@end

@implementation Child (Ext2)

+ (void)load{
    if(!steps){
        steps = [NSMutableArray array];
    }
    [steps addObject:@"ChildExt2"];
}

@end

// DIVIDE

@interface LoadViewController ()

@end

@implementation LoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)testLoadOrder{
    // +load执行顺序: 父类->子类->分类
    BOOL ordered = [steps isEqualToArray:@[ @"People", @"Child", @"ChildExt", @"ChildExt2" ]];
    NSAssert(ordered, @"+load执行顺序");
}

@end
