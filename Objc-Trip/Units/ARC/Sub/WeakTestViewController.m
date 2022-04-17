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
@property (nonatomic, weak) NSArray *weakArr;
@end

//__weak NSArray *self.weakArr;

@implementation WeakTestViewController{
    BOOL expectWillAppearNil;
    BOOL expectDidAppearNil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.testcase == 1){
        [self testArray1];
    }
    
    if(self.testcase == 2){
        [self testArray2];
    }
    
    if(self.testcase == 3){
        [self testArray3];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)testArray1{
    // 场景 1
    NSArray *array = [NSArray arrayWithObjects:@1, @2, nil];
    [BaseUtil checkAutoRelease:getAddr(array) result:^(BOOL isAuto) {
        NSAssert(isAuto, @"array为autorelease");
    }];
    
    self.weakArr = array;
    
    NSAssert(self.weakArr, @"self.weakArr不为nil");
    expectWillAppearNil = NO;
    // INFO: viewDidAppear时weak对象已销毁?
    expectDidAppearNil = YES;
}

-(void)testArray2{
    // 场景 2
    @autoreleasepool {
        NSArray *array = [NSArray arrayWithObjects:@1, @2, nil];
        self.weakArr = array;
    }
    
    NSAssert(!self.weakArr, @"self.weakArr为nil");
    expectWillAppearNil = YES;
    expectDidAppearNil = YES;
}

-(void)testArray3{
    // 场景 3
    NSArray *array;
    @autoreleasepool {
        array = [NSArray arrayWithObjects:@1, @2, nil];
        self.weakArr = array;
    }
    
    // INFO: array又变回非autorelease?
    [BaseUtil checkAutoRelease:getAddr(array) result:^(BOOL isAuto) {
        NSAssert(!isAuto, @"array不为autorelease");
    }];
    
    NSAssert(self.weakArr, @"self.weakArr不为nil");
    expectWillAppearNil = YES;
    expectDidAppearNil = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(expectWillAppearNil){
        NSAssert(!self.weakArr, @"self.weakArr为nil");
    }
    else{
        NSAssert(self.weakArr, @"self.weakArr不为nil");
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if(expectDidAppearNil){
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
