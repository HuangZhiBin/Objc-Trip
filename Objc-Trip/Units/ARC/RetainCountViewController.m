//
//  RetainCountViewController.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/10.
//

#import "RetainCountViewController.h"

@interface RetainCountViewController ()

@end

@implementation RetainCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)groupString{}

-(void)testString{
    id str0 = @"123";
    NSAssert([NSStringFromClass([str0 class]) isEqualToString:@"__NSCFConstantString"], @"类型为Constant");
    
    id str1 = @"1234567890";
    NSAssert([NSStringFromClass([str1 class]) isEqualToString:@"__NSCFConstantString"], @"类型为Constant");
    
    id str2 = [NSString string];
    NSAssert([NSStringFromClass([str2 class]) isEqualToString:@"__NSCFConstantString"], @"类型为Constant");
    
    id str3 = [[NSString alloc] init];
    NSAssert([NSStringFromClass([str3 class]) isEqualToString:@"__NSCFConstantString"], @"类型为Constant");
    
    // INFO:stringWithString的类型取决于它后面跟的string对象
    id str4 = [NSString stringWithString:@"1234567890"];
    NSAssert([NSStringFromClass([str4 class]) isEqualToString:@"__NSCFConstantString"], @"类型为Constant");
    
    // INFO:stringWithFormat决定类型为NSTaggedPointerString还是__NSCFString
    id str5 = [NSString stringWithString:[NSString stringWithFormat:@"%@", @"123456789"]];
    NSAssert([NSStringFromClass([str5 class]) isEqualToString:@"NSTaggedPointerString"], @"类型为TaggedPointer");
    
    id str6 = [NSString stringWithString:[NSString stringWithFormat:@"%@", @"1234567890"]];
    NSAssert([NSStringFromClass([str6 class]) isEqualToString:@"__NSCFString"], @"类型为NSCFString");
    
    id str7 = [NSString stringWithFormat:@"%@", @"123456789"];
    NSAssert([NSStringFromClass([str7 class]) isEqualToString:@"NSTaggedPointerString"], @"类型为TaggedPointer");
    
    // INFO:stringWithFormat生成的NSCFString类型引用计数为2
    id str8 = [NSString stringWithFormat:@"%@", @"1234567890"];
    NSAssert([NSStringFromClass([str8 class]) isEqualToString:@"__NSCFString"], @"类型为NSCFString");
    
    // INFO:Constant和TaggedPointer无引用计数
    NSAssert(
             RetainCount(str0) == 1152921504606846975 &&
             RetainCount(str1) == 1152921504606846975 &&
             RetainCount(str2) == 1152921504606846975 &&
             RetainCount(str3) == 1152921504606846975 &&
             RetainCount(str4) == 1152921504606846975 &&
             RetainCount(str5) == 9223372036854775807 &&
             RetainCount(str7) == 9223372036854775807,
             @"Constant和TaggedPointer引用计数!=1"
    );
    
    // INFO:NSCFString有引用计数
    NSAssert(
             RetainCount(str6) == 2 &&
             RetainCount(str8) == 2,
             @"NSCFString引用计数==2"
    );
    
    id str9 = str8;
    NSAssert(
             RetainCount(str9) == 3,
             @"str9引用计数==3"
    );
}

-(void)testMutableString{
    // INFO:可变类型的都是__NSCFString
    id m_str = [@"123" mutableCopy];
    NSAssert(RetainCount(m_str) == 1, @"m_str引用计数==1");
    
    id m_str2 = [NSMutableString string];
    NSAssert(RetainCount(m_str2) == 1, @"m_str2引用计数==1");
    
    id m_str3 = [[NSMutableString alloc] init];
    NSAssert(RetainCount(m_str3) == 1, @"m_str3引用计数==1");
    
    id m_str4 = [NSMutableString stringWithString: @"12345"];
    NSAssert(RetainCount(m_str4) == 1, @"m_str4引用计数==1");
    
    id m_str5 = [NSMutableString stringWithFormat:@"%@", @"12345"];
    NSAssert(RetainCount(m_str5) == 2, @"m_str5引用计数==2");
    
    id m_str6 = [NSMutableString stringWithFormat:@"%@", @"1234567890"];
    NSAssert(RetainCount(m_str6) == 2, @"m_str6引用计数==2");
    
    NSAssert(
             [NSStringFromClass([m_str class]) isEqualToString:@"__NSCFString"] &&
             [NSStringFromClass([m_str2 class]) isEqualToString:@"__NSCFString"] &&
             [NSStringFromClass([m_str3 class]) isEqualToString:@"__NSCFString"] &&
             [NSStringFromClass([m_str4 class]) isEqualToString:@"__NSCFString"] &&
             [NSStringFromClass([m_str5 class]) isEqualToString:@"__NSCFString"],
             @"类型为NSCFString"
    );
}

-(void)groupArray{}

-(void)testNSArray{
    
}

-(void)testMutableArray{
    
}

-(void)groupDifferentType{}

-(void)test__weak{
    id strong_obj = [NSMutableArray array];
    __weak id weak_obj = strong_obj;
    
    NSAssert(RetainCount(strong_obj) == 1, @"strong_obj引用计数==1");
    // INFO:weak_obj引用计数==2
    NSAssert(RetainCount(weak_obj) == 2, @"weak_obj引用计数==2");
}

-(void)test__unsafe_unretained{
    id strong_obj = [NSMutableArray array];
    __unsafe_unretained id unsafe_unretained_obj = strong_obj;
    
    NSAssert(RetainCount(strong_obj) == 1, @"strong_obj引用计数==1");
    NSAssert(RetainCount(unsafe_unretained_obj) == 1, @"unsafe_unretained_obj引用计数==1");
}

-(void)test__strong{
    id strong_obj = [NSMutableArray array];
    // 等同于__strong
    id strong_obj2 = strong_obj;
    NSAssert(RetainCount(strong_obj) == 2, @"strong_obj引用计数==2");
    NSAssert(RetainCount(strong_obj2) == 2, @"strong_obj2引用计数==2");
}

-(void)test__autoreleasing{
    id strong_obj = [NSMutableArray array];
    __autoreleasing id autoreleasing_obj = strong_obj;
    
    NSAssert(RetainCount(strong_obj) == 2, @"strong_obj引用计数==2");
    NSAssert(RetainCount(autoreleasing_obj) == 2, @"autoreleasing_obj引用计数==2");
    
    @autoreleasepool {
        __autoreleasing id autoreleasing_obj2 = strong_obj;
        NSAssert(RetainCount(autoreleasing_obj2) == 3, @"autoreleasing_obj引用计数==3");
    }
    NSAssert(RetainCount(strong_obj) == 2, @"strong_obj引用计数==2");
}

-(void)groupAssignment{}

-(void)test__weak_assignment{
    __weak id weakObj = [NSMutableArray array];
    NSAssert(!weakObj, @"赋值给__weak时，weakObj为nil");
}

-(void)test__unretain_assignment{
    __unsafe_unretained id unretainObj = [NSMutableArray array];
    NSAssert(unretainObj, @"赋值给__unsafe_unretained时，unretainObj不为nil");
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
