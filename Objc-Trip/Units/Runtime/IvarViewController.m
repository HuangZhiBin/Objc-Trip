//
//  IvarViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/25.
//

#import "IvarViewController.h"
#import <objc/runtime.h>

@interface IvarModel: NSObject

@property (nonatomic,copy) NSString *name;

@end

@implementation IvarModel
{
    NSInteger _index;
}

@end

@interface IvarViewController ()

@end

@implementation IvarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)testIvar_PropertyList{
    unsigned int propertiesCount = 0;
    unsigned int ivarsCount = 0;
    objc_property_t *properties = class_copyPropertyList([IvarModel class], &propertiesCount);
    Ivar *ivars = class_copyIvarList([IvarModel class], &ivarsCount);
    
    NSAssert(propertiesCount == 1, @"class_copyPropertyList得到的属性count为1");
    NSAssert(ivarsCount == 2, @"class_copyIvarList得到的变量count为2");
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
