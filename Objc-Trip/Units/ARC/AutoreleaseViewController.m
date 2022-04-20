//
//  AutoreleaseViewController.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/7.
//

#import "AutoreleaseViewController.h"

@implementation AutoreleaseViewController{
    NSArray *numArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    numArray = [BaseUtil arrayWithLength:1000000];
}

-(void)testNonAutorelease{
    // INFO: alloc/new/copy/mutableCopy之外的方法，对象注册到autoreleasepool
    
    id allocObj = [NSString alloc];
    [BaseUtil checkAutoRelease:getAddr(allocObj) result:^(BOOL isAuto) {
        NSAssert(!isAuto, @"allocObj不为autorelease");
    }];
    
    id newObj = [NSString new];
    [BaseUtil checkAutoRelease:getAddr(newObj) result:^(BOOL isAuto) {
        NSAssert(!isAuto, @"newObj不为autorelease");
    }];
    
    id copyObj = [@"abc" copy];
    [BaseUtil checkAutoRelease:getAddr(copyObj) result:^(BOOL isAuto) {
        NSAssert(!isAuto, @"copyObj不为autorelease");
    }];
    
    id mutableCopy = [@"abc" mutableCopy];
    [BaseUtil checkAutoRelease:getAddr(mutableCopy) result:^(BOOL isAuto) {
        NSAssert(!isAuto, @"mutableCopy不为autorelease");
    }];
}

-(void)testString{
    id str6 = [NSString stringWithString:[NSString stringWithFormat:@"%@", @"1234567890"]];
    [BaseUtil checkAutoRelease:getAddr(str6) result:^(BOOL isAuto) {
        NSAssert(isAuto, @"为autorelease");
    }];
    
    id str8 = [NSString stringWithFormat:@"%@", @"1234567890"];
    [BaseUtil checkAutoRelease:getAddr(str8) result:^(BOOL isAuto) {
        NSAssert(isAuto, @"为autorelease");
    }];
    
    id m_str5 = [NSMutableString stringWithFormat:@"%@", @"12345"];
    [BaseUtil checkAutoRelease:getAddr(m_str5) result:^(BOOL isAuto) {
        NSAssert(isAuto, @"为autorelease");
    }];
    
    id m_str6 = [NSMutableString stringWithFormat:@"%@", @"1234567890"];
    [BaseUtil checkAutoRelease:getAddr(m_str6) result:^(BOOL isAuto) {
        NSAssert(isAuto, @"为autorelease");
    }];
}

-(void)testArray{
    id arr5 = [NSArray arrayWithObjects:@1, nil];
    [BaseUtil checkAutoRelease:getAddr(arr5) result:^(BOOL isAuto) {
        NSAssert(isAuto, @"为autorelease");
    }];
    
    id arr7 = [NSMutableArray arrayWithObjects:@1, nil];
    [BaseUtil checkAutoRelease:getAddr(arr7) result:^(BOOL isAuto) {
        NSAssert(isAuto, @"为autorelease");
    }];
}

-(void)test__weak{
    NSObject *obj = [[NSObject alloc] init];
    id __weak weakObj = obj;
    [BaseUtil checkAutoRelease:getAddr(weakObj) result:^(BOOL isAuto) {
        NSAssert(!isAuto, @"weakObj不为autorelease");
    }];
    
    // INFO: 使用weak对象时添加到autoreleasepool
    id desc1 = [weakObj description];
    id desc2 = [weakObj description];
    [BaseUtil checkAutoRelease:getAddr(weakObj) result:^(BOOL isAuto) {
        NSAssert(!isAuto, @"weakObj不为autorelease");
    }];
    [BaseUtil checkAutoRelease:getAddr(desc1) result:^(BOOL isAuto) {
        NSAssert(isAuto, @"desc1为autorelease");
    }];
    [BaseUtil checkAutoRelease:getAddr(desc2) result:^(BOOL isAuto) {
        NSAssert(isAuto, @"desc2为autorelease");
    }];
    
    BOOL isEqual = [getAddr(desc1) isEqualToString:getAddr(desc2)];
    NSAssert(!isEqual, @"desc1和desc2不是同一个对象");
}

-(void)test__autoreleasing{
    NSObject *obj = [[NSObject alloc] init];
    id __weak weakObj = obj;
    id __autoreleasing autoObj = obj;
    [BaseUtil checkAutoRelease:getAddr(obj) result:^(BOOL isAuto) {
        NSAssert(isAuto, @"obj为autorelease");
    }];
    [BaseUtil checkAutoRelease:getAddr(weakObj) result:^(BOOL isAuto) {
        NSAssert(isAuto, @"weakObj为autorelease");
    }];
    [BaseUtil checkAutoRelease:getAddr(autoObj) result:^(BOOL isAuto) {
        NSAssert(isAuto, @"autoObj为autorelease");
    }];
}

-(void)groupMassive{}

-(void)testMassive1{
    for(int i = 0; i < 1000000; i++){
        // INFO: autorelease对象急剧增多，内存暴涨
//        NSString *str = @"Hello";
        NSNumber *num = [NSNumber numberWithInt:i];
        NSString *str = [NSString stringWithFormat:@"%d ", i];
        [NSString stringWithFormat:@"%@%@", num, str];
    }
}

-(void)testMassive2{
    for(int i = 0; i < 1000000; i++){
        // INFO: @autoreleasepool即时释放，内存不暴涨
        @autoreleasepool {
//            NSString *str = @"Hello";
            NSNumber *num = [NSNumber numberWithInt:i];
            NSString *str = [NSString stringWithFormat:@"%d ", i];
            [NSString stringWithFormat:@"%@%@", num, str];
        }
    }
}

-(void)testMassive3{
    // INFO: UsingBlock包含@autoreleasepool，内存不暴涨
    [numArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {
//        NSString *str = @"Hello";
        NSNumber *num = [NSNumber numberWithUnsignedLong:i];
        NSString *str = [NSString stringWithFormat:@"%ld", i];
        [NSString stringWithFormat:@"%@%@", num, str];
    }];
}

@end
