//
//  Son.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/15.
//

#import "Son.h"

@implementation Son

- (id)init{
    self = [super init];
    if (self) {
        [self testSon];
    }
    return self;
}

-(void)testSon{
    NSAssert([NSStringFromClass([self class]) isEqualToString:@"Son"], @"接受消息的对象都是当前Son对象，调用Son的方法");
    NSAssert([NSStringFromClass([super class]) isEqualToString:@"Son"], @"接受消息的对象都是当前Son对象，调用Father的方法");
}

@end
