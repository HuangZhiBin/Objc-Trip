//
//  WeakStrTestViewController.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/8.
//

#import "WeakStrTestViewController.h"
#import "BaseUtil.h"

static NSString * const TAG = @"abc";

@interface WeakStrTestViewController ()
@property (nonatomic, weak) NSString *weakStr;
@end

//__weak NSString *self.weakStr;

@implementation WeakStrTestViewController{
    BOOL expectWillAppearNil;
    BOOL expectDidAppearNil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.testcase == 1){
        [self testString1];
    }
    
    if(self.testcase == 2){
        [self testString2];
    }
    
    if(self.testcase == 3){
        [self testString3];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)testString1{
    // 场景 1
    NSString *String = [NSString stringWithFormat:@"%@",@"++test123"];
    [BaseUtil checkAutoRelease:getAddr(String) result:^(BOOL isAuto) {
        NSAssert(isAuto, @"String为autorelease");
    }];
    self.weakStr = String;
    
    NSAssert(self.weakStr, @"self.weakStr不为nil");
    expectWillAppearNil = NO;
    // INFO: viewDidAppear时weak对象已销毁?
    expectDidAppearNil = YES;
}

-(void)testString2{
    // 场景 2
    @autoreleasepool {
        NSString *String = [NSString stringWithFormat:@"%@",@"++test123"];
        self.weakStr = String;
    }
    
    NSAssert(!self.weakStr, @"self.weakStr为nil");
    expectWillAppearNil = YES;
    expectDidAppearNil = YES;
}

-(void)testString3{
    // 场景 3
    NSString *String;
    @autoreleasepool {
        String = [NSString stringWithFormat:@"%@",@"++test123"];
        self.weakStr = String;
    }
    
    // INFO: String又变回非autorelease?
    [BaseUtil checkAutoRelease:getAddr(String) result:^(BOOL isAuto) {
        NSAssert(!isAuto, @"String不为autorelease");
    }];
    
    NSAssert(self.weakStr, @"self.weakStr不为nil");
    expectWillAppearNil = YES;
    expectDidAppearNil = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(expectWillAppearNil){
        NSAssert(!self.weakStr, @"self.weakStr为nil");
    }
    else{
        NSAssert(self.weakStr, @"self.weakStr不为nil");
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(expectDidAppearNil){
        NSAssert(!self.weakStr, @"self.weakStr为nil");
    }
    else{
        NSAssert(self.weakStr, @"self.weakStr不为nil");
    }
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
