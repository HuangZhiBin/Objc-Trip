//
//  ForwardTargetViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/24.
//

#import "ForwardTargetViewController.h"

static int executeRst;
// DIVIDE
// INFO: 目标类
@interface ForwardTargetModel : NSObject

@end

@implementation ForwardTargetModel

-(void)targetFunc{
    executeRst = 1;
}

@end
// DIVIDE
// INFO: 原有类

@interface ForwardSourceModel : NSObject

@end

@implementation ForwardSourceModel

- (id)forwardingTargetForSelector:(SEL)aSelector{
    if([NSStringFromSelector(aSelector) isEqualToString:@"targetFunc"]){
        return [ForwardTargetModel new];
    }
    return [super forwardingTargetForSelector:aSelector];
}

@end

// DIVIDE

@interface ForwardTargetViewController ()

@end

@implementation ForwardTargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)test{
    executeRst = 0;
    [[ForwardSourceModel new] performSelector:NSSelectorFromString(@"targetFunc")];
    NSAssert(executeRst == 1, @"方法执行了");
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
