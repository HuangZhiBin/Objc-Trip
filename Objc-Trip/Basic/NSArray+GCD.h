//
//  NSMutableArray+GCD.h
//  Objc-Trip
//
//  Created by Binhuang on 2022/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (GCD)

-(BOOL)isOrderedBySteps:(NSString *)steps;
-(BOOL)isRandomBySteps:(NSString *)steps;

@end

NS_ASSUME_NONNULL_END
