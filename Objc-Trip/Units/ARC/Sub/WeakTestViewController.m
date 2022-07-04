//
//  WeakViewController.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/8.
//

#import "WeakTestViewController.h"
#import "BaseUtil.h"

static NSString * const TAG = @"abc";

@interface WeakTestViewController ()
@property (nonatomic, weak) NSString *weakStr;
@property (nonatomic, weak) NSArray *weakArr;
@end

//__weak NSArray *self.weakArr;

@implementation WeakTestViewController{
    BOOL expectStringWillAppearNil;
    BOOL expectStringDidAppearNil;
    BOOL expectArrWillAppearNil;
    BOOL expectArrDidAppearNil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    expectStringWillAppearNil = YES;
    expectStringDidAppearNil = YES;
    expectArrWillAppearNil = YES;
    expectArrDidAppearNil = YES;
    
    [self performSelector:NSSelectorFromString(self.testcase)];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)testString1{
    // 场景 1
    NSString *string = [NSString stringWithFormat:@"%@",@"++test123"];
    
    self.weakStr = string;
    [BaseUtil checkAutoRelease:getAddr(self.weakStr) result:^(BOOL isAuto) {
        NSAssert(isAuto, @"String为autorelease");
    }];
    
    NSAssert(self.weakStr, @"self.weakStr不为nil");
    expectStringWillAppearNil = NO;
    // QUIZ: viewDidAppear时weak对象已销毁?
    expectStringDidAppearNil = YES;
}

-(void)testString2{
    // 场景 2
    @autoreleasepool {
        NSString *string = [NSString stringWithFormat:@"%@",@"++test123"];
        self.weakStr = string;
    }
    
    NSAssert(!self.weakStr, @"self.weakStr为nil");
    expectStringWillAppearNil = YES;
    expectStringDidAppearNil = YES;
}

-(void)testString3{
    // 场景 3
    NSString *string;
    @autoreleasepool {
        string = [NSString stringWithFormat:@"%@",@"++test123"];
        [BaseUtil checkAutoRelease:getAddr(string) result:^(BOOL isAuto) {
            NSAssert(isAuto, @"String为autorelease");
        }];
        
        self.weakStr = string;
    }
    
    // INFO: String又变回非autorelease?
    [BaseUtil checkAutoRelease:getAddr(string) result:^(BOOL isAuto) {
        NSAssert(!isAuto, @"String不为autorelease");
    }];
    
    NSAssert(self.weakStr, @"self.weakStr不为nil");
    expectStringWillAppearNil = YES;
    expectStringDidAppearNil = YES;
}

-(void)testArray1{
    // 场景 1
    NSArray *array = [NSArray arrayWithObjects:@1, @2, nil];
    [BaseUtil checkAutoRelease:getAddr(array) result:^(BOOL isAuto) {
        NSAssert(isAuto, @"array为autorelease");
    }];
    
    self.weakArr = array;
    
    NSAssert(self.weakArr, @"self.weakArr不为nil");
    expectArrWillAppearNil = NO;
    expectArrDidAppearNil = YES;
}

-(void)testArray2{
    // 场景 2
    @autoreleasepool {
        NSArray *array = [NSArray arrayWithObjects:@1, @2, nil];
        self.weakArr = array;
    }
    
    NSAssert(!self.weakArr, @"self.weakArr为nil");
    expectArrWillAppearNil = YES;
    expectArrDidAppearNil = YES;
}

-(void)testArray3{
    // 场景 3
    NSArray *array;
    @autoreleasepool {
        array = [NSArray arrayWithObjects:@1, @2, nil];
        self.weakArr = array;
    }
    
    // QUIZ: array又变回非autorelease?
    [BaseUtil checkAutoRelease:getAddr(array) result:^(BOOL isAuto) {
        NSAssert(!isAuto, @"array不为autorelease");
    }];
    
    NSAssert(self.weakArr, @"self.weakArr不为nil");
    expectArrWillAppearNil = YES;
    expectArrDidAppearNil = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(expectStringWillAppearNil){
        NSAssert(!self.weakStr, @"self.weakStr为nil");
    }
    else{
        NSAssert(self.weakStr, @"self.weakStr不为nil");
    }
    
    if(expectArrWillAppearNil){
        NSAssert(!self.weakArr, @"self.weakArr为nil");
    }
    else{
        NSAssert(self.weakArr, @"self.weakArr不为nil");
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(expectStringDidAppearNil){
        NSAssert(!self.weakStr, @"self.weakStr为nil");
    }
    else{
        NSAssert(self.weakStr, @"self.weakStr不为nil");
    }
    
    if(expectArrDidAppearNil){
        NSAssert(!self.weakArr, @"self.weakArr为nil");
    }
    else{
        NSAssert(self.weakArr, @"self.weakArr不为nil");
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
