//
//  TypeUtil.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/18.
//

#import "TypeUtil.h"

@implementation TypeUtil

+(BOOL)string_type_is_constant:(id)obj{
    return [NSStringFromClass([obj class]) isEqualToString:@"__NSCFConstantString"];
}

+(BOOL)string_type_is_tagged_pointer:(id)obj{
    return [NSStringFromClass([obj class]) isEqualToString:@"NSTaggedPointerString"];
}

+(BOOL)string_type_is_cfstring:(id)obj{
    return [NSStringFromClass([obj class]) isEqualToString:@"__NSCFString"];
}

+(BOOL)array_type_is_array0:(id)obj{
    return [NSStringFromClass([obj class]) isEqualToString:@"__NSArray0"];
}

+(BOOL)array_type_is_constant:(id)obj{
    return [NSStringFromClass([obj class]) isEqualToString:@"NSConstantArray"];
}

+(BOOL)array_type_is_single_object:(id)obj{
    return [NSStringFromClass([obj class]) isEqualToString:@"__NSSingleObjectArrayI"];
}

+(BOOL)array_type_is_immutable:(id)obj{
    return [NSStringFromClass([obj class]) isEqualToString:@"__NSArrayI"];
}

+(BOOL)array_type_is_mutable:(id)obj{
    return [NSStringFromClass([obj class]) isEqualToString:@"__NSArrayM"];
}

@end
