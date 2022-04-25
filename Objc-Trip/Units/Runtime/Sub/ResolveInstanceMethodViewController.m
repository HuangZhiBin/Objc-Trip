//
//  ResolveInstanceMethodViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/24.
//

#import "ResolveInstanceMethodViewController.h"
#import <objc/runtime.h>

static int executeRst;

// DIVIDE
@interface ResolveInstanceModel : NSObject

@end

@implementation ResolveInstanceModel

+(BOOL)resolveInstanceMethod:(SEL)sel{
    if ([NSStringFromSelector(sel) isEqualToString:@"testFunction"]) {
        class_addMethod([self class], sel, (IMP)fooMethod, "v@:");
        //void + obj + cmd
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

void fooMethod(id obj, SEL _cmd){
    executeRst = 1;
}

@end
// DIVIDE
@interface ResolveInstanceMethodViewController ()

@end

@implementation ResolveInstanceMethodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)test{
    executeRst = 0;
    ResolveInstanceModel *model = [[ResolveInstanceModel alloc] init];
    [model performSelector:NSSelectorFromString(@"testFunction")];
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
