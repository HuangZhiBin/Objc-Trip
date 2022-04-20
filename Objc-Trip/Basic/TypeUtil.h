//
//  TypeUtil.h
//  Objc-Trip
//
//  Created by binhuang on 2022/4/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TypeUtil : NSObject
+(BOOL)string_type_is_constant:(id)obj;

+(BOOL)string_type_is_tagged_pointer:(id)obj;

+(BOOL)string_type_is_cfstring:(id)obj;

+(BOOL)array_type_is_array0:(id)obj;

+(BOOL)array_type_is_constant:(id)obj;

+(BOOL)array_type_is_single_object:(id)obj;

+(BOOL)array_type_is_immutable:(id)obj;

+(BOOL)array_type_is_mutable:(id)obj;
@end

NS_ASSUME_NONNULL_END
