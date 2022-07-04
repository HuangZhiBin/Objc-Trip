//
//  InitializeViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/25.
//

#import "InitializeViewController.h"

static NSMutableArray *steps;

// DIVIDE

@interface Language : NSObject

@end

@implementation Language

+ (void)initialize{
    if(!steps){
        steps = [NSMutableArray array];
    }
    [steps addObject:@"Language"];
}

@end

// DIVIDE

@interface Spanish : Language

@end

@implementation Spanish

+ (void)initialize{
    if(!steps){
        steps = [NSMutableArray array];
    }
    [steps addObject:@"Spanish"];
}

@end

// DIVIDE

@interface Spanish (Ext)

@end

@implementation Spanish (Ext)

+ (void)initialize{
    if(!steps){
        steps = [NSMutableArray array];
    }
    [steps addObject:@"SpanishExt"];
}

@end

// DIVIDE

@interface Spanish (Ext2)

@end

@implementation Spanish (Ext2)

+ (void)initialize{
    if(!steps){
        steps = [NSMutableArray array];
    }
    [steps addObject:@"SpanishExt2"];
}

@end

// DIVIDE

@interface InitializeViewController ()

@end

@implementation InitializeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)testInitializeOrder{
    // +initialize执行顺序: 父类->子类，分类覆盖了子类方法，只执行分类方法
    [Spanish new];
    BOOL ordered = [steps isEqualToArray:@[ @"Language", @"SpanishExt2" ]];
    NSAssert(ordered, @"+initialize执行顺序");
}

@end
