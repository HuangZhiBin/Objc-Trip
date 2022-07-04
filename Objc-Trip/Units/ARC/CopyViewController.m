//
//  CopyViewController.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/8.
//

#import "CopyViewController.h"

@interface CopyViewController ()

@property (nonatomic, copy) NSString *cTxt;
@property (nonatomic, strong) NSString *sTxt;
@property (nonatomic, copy) NSMutableString *cMTxt;
@property (nonatomic, strong) NSMutableString *sMTxt;

@end

@implementation CopyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)groupNSString{}

-(void)test_copy_string{
    NSString *str = [NSString stringWithFormat:@"%@",@"1234567890"];
    // INFO: copy生成的对象都是不可变的
    id obj = [str copy];
    // INFO: 不可变对象copy生成的对象为浅拷贝，其余的都是深拷贝
    NSAssert([getAddr(str) isEqualToString:getAddr(obj)], @"--浅拷贝--");
}

-(void)test_mutablecopy_string{
    int a[10];
    NSString *str = [NSString string];
    // INFO: mutableCopy生成的对象都是可变的
    id obj = [str mutableCopy];
    NSAssert(![getAddr(str) isEqualToString:getAddr(obj)], @"++深拷贝++");
}

-(void)test_copy_mutablestring{
    NSMutableString *str = [NSMutableString string];
    id obj = [str copy];
    NSAssert(![getAddr(str) isEqualToString:getAddr(obj)], @"++深拷贝++");
}

-(void)test_mutablecopy_mutablestring{
    NSMutableString *str = [NSMutableString string];
    id obj = [str mutableCopy];
    NSAssert(![getAddr(str) isEqualToString:getAddr(obj)], @"++深拷贝++");
}

-(void)groupProperty{}

-(void)test_immutable_copy_property{
    self.cTxt = @"Old";
    NSMutableString *newUserName = [[NSMutableString alloc] initWithString:@"New"];
    self.cTxt = newUserName;
    [newUserName appendString:@"-More"];
    NSAssert([self.cTxt isEqualToString:@"New"], @"得到不可变对象");
}

-(void)test_immutable_strong_property{
    self.sTxt = @"Old";
    NSMutableString *newUserName = [[NSMutableString alloc] initWithString:@"New"];
    self.sTxt = newUserName;
    [newUserName appendString:@"-More"];
    NSAssert([self.sTxt isEqualToString:@"New-More"], @"得到可变对象");
}

-(void)test_mutable_copy_property_0{
    self.cMTxt = [NSMutableString stringWithString:@"Old"];
    NSMutableString *newUserName = [[NSMutableString alloc] initWithString:@"New"];
    self.cMTxt = newUserName;
    [newUserName appendString:@"-More"];
    NSAssert([self.cMTxt isEqualToString:@"New"], @"得到不可变对象");
    SafeExit();
    // INFO:此时对cMtxt执行appendString:会crash
    [self.cMTxt appendString:@"-Extra"];
}

-(void)test_mutable_strong_property{
    self.sMTxt = [NSMutableString stringWithString:@"Old"];
    NSMutableString *newUserName = [[NSMutableString alloc] initWithString:@"New"];
    self.sMTxt = newUserName;
    [newUserName appendString:@"-More"];
    NSAssert([self.sMTxt isEqualToString:@"New-More"], @"得到可变对象");
}

-(void)groupArray{}

-(void)test_copy_array{
    NSArray *str = [NSArray array];
    id obj = [str copy];
    NSAssert(![obj isKindOfClass:[NSMutableArray class]], @"NSArray copy得到的是不可变对象");
    NSAssert([getAddr(str) isEqualToString:getAddr(obj)], @"--浅拷贝--");
}

-(void)test_mutablecopy_array{
    NSArray *str = [NSArray array];
    id obj = [str mutableCopy];
    NSAssert([obj isKindOfClass:[NSMutableArray class]], @"NSArray mutableCopy得到的是可变对象");
    NSAssert(![getAddr(str) isEqualToString:getAddr(obj)], @"++深拷贝++");
}

-(void)test_copy_mutablearray{
    NSMutableArray *str = [NSMutableArray array];
    id obj = [str copy];
    NSAssert(![obj isKindOfClass:[NSMutableArray class]], @"NSMutableArray copy得到的是不可变对象");
    NSAssert(![getAddr(str) isEqualToString:getAddr(obj)], @"++深拷贝++");
}

-(void)test_mutablecopy_mutablearray{
    NSMutableArray *str = [NSMutableArray array];
    id obj = [str mutableCopy];
    NSAssert([obj isKindOfClass:[NSMutableArray class]], @"NSMutableArray mutableCopy得到的是可变对象");
    NSAssert(![getAddr(str) isEqualToString:getAddr(obj)], @"++深拷贝++");
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
