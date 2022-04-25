//
//  ForwardInvocationViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/24.
//

#import "ForwardInvocationViewController.h"
static int executeRst;

// DIVIDE
// INFO: 目标类1
@interface ForwardInvocationTargetModel1 : NSObject

@end

@implementation ForwardInvocationTargetModel1

-(void)targetFunc{
    executeRst++;
}

@end
// DIVIDE
// INFO: 目标类2
@interface ForwardInvocationTargetModel2 : NSObject

@end

@implementation ForwardInvocationTargetModel2
-(void)targetFunc{
    executeRst++;
}
@end
// DIVIDE
// INFO: 原有类
@interface ForwardInvocationModel : NSObject

@end

@implementation ForwardInvocationModel

// INFO: forwardInvocation+methodSignatureForSelector重载两个方法
- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL sel = invocation.selector;
    
    if(sel == NSSelectorFromString(@"targetFunc")){
        // INFO: 可以连续转发给多个对象
        if([[ForwardInvocationTargetModel1 new] respondsToSelector:sel]) {
            [invocation invokeWithTarget:[ForwardInvocationTargetModel1 new]];
        }
        
        if([[ForwardInvocationTargetModel2 new] respondsToSelector:sel]) {
            [invocation invokeWithTarget:[ForwardInvocationTargetModel2 new]];
        }
        
        return;
    }
    
    [self doesNotRecognizeSelector:sel];
}

-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSMethodSignature *methodSignature = [super methodSignatureForSelector:aSelector];
    if (!methodSignature) {
        methodSignature = [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return methodSignature;
}

@end

// DIVIDE

@interface ForwardInvocationViewController ()

@end

@implementation ForwardInvocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)test{
    executeRst = 0;
    [[ForwardInvocationModel new] performSelector:NSSelectorFromString(@"targetFunc")];
    NSAssert(executeRst == 2, @"方法执行了两次");
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
