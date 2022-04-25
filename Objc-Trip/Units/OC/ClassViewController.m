//
//  ClassViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/25.
//

#import "ClassViewController.h"
#import <objc/runtime.h>

@interface ClassViewController ()

@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)test_class{
    
    // INFO:object_getClass入参是class，则和[obj class]不一样，等于isa指向的对象
    Class cls2 = object_getClass([self class]);
    NSAssert(![cls2 isEqual:[self class]], @"");
    
    // INFO:object_getClass入参是对象obj，则和[obj class]一样
    Class cls22 = object_getClass(self);
    NSAssert([cls22 isEqual:[self class]], @"");
    
    // INFO:objc_getClass入参是className
    Class cls3 = objc_getClass(object_getClassName([self class]));
    NSAssert([cls3 isEqual:[self class]], @"");
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
