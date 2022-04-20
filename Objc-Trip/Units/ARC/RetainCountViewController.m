//
//  RetainCountViewController.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/10.
//

#import "RetainCountViewController.h"
#import "TypeUtil.h"

@interface RetainCountViewController ()

@end

@implementation RetainCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)groupString{}

-(void)testConstantString{
    // INFO:Constant无引用计数
    void (^checkConstantString)(id) = ^(id obj){
        NSAssert([TypeUtil string_type_is_constant:obj], @"类型为Constant");
        NSAssert(RetainCount(obj) != 1 && RetainCount(obj) != 2, @"无引用计数");
    };
    
    id str0 = @"123";
    checkConstantString(str0);
    
    id str1 = @"1234567890";
    checkConstantString(str1);
    
    id str2 = [NSString string];
    checkConstantString(str2);
    
    id str3 = [[NSString alloc] init];
    checkConstantString(str3);
    
    id str4 = [NSString stringWithString:@"1234567890"];
    checkConstantString(str4);
}

-(void)testTaggedPointerString{
    // INFO:TaggedPointer无引用计数
    void (^checkTaggedPointerString)(id) = ^(id obj){
        NSAssert([TypeUtil string_type_is_tagged_pointer:obj], @"类型为TaggedPointer");
        NSAssert(RetainCount(obj) != 1 && RetainCount(obj) != 2, @"无引用计数");
    };
    
    // INFO:stringWithFormat决定类型为NSTaggedPointerString还是__NSCFString
    id str5 = [NSString stringWithString:[NSString stringWithFormat:@"%@", @"123456789"]];
    checkTaggedPointerString(str5);
    
    id str7 = [NSString stringWithFormat:@"%@", @"123456789"];
    checkTaggedPointerString(str7);
}

-(void)testCFString{
    // INFO:CFString有引用计数
    void (^checkCFString)(id) = ^(__unsafe_unretained id obj){
        NSAssert([TypeUtil string_type_is_cfstring:obj], @"类型为CFString");
        NSAssert(RetainCount(obj) == 1 || RetainCount(obj) == 2, @"有引用计数");
    };
    
    id str6 = [NSString stringWithString:[NSString stringWithFormat:@"%@", @"1234567890"]];
    checkCFString(str6);
    
    id str8 = [NSString stringWithFormat:@"%@", @"1234567890"];
    checkCFString(str8);
}

-(void)testMutableString{
    // INFO:CFString有引用计数
    void (^checkCFString)(id) = ^(__unsafe_unretained id obj){
        NSAssert([TypeUtil string_type_is_cfstring:obj], @"类型为CFString");
        NSAssert(RetainCount(obj) == 1 || RetainCount(obj) == 2, @"有引用计数");
    };
    
    id m_str = [@"123" mutableCopy];
    checkCFString(m_str);

    id m_str2 = [NSMutableString string];
    checkCFString(m_str2);

    id m_str3 = [[NSMutableString alloc] init];
    checkCFString(m_str3);

    id m_str4 = [NSMutableString stringWithString: @"12345"];
    checkCFString(m_str4);
    
    id m_str5 = [NSMutableString stringWithFormat:@"%@", @"12345"];
    checkCFString(m_str5);
    
    id m_str6 = [NSMutableString stringWithFormat:@"%@", @"1234567890"];
    checkCFString(m_str6);
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
