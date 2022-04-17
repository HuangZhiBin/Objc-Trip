//
//  NSMutableArray+NSMutableArray_GCD.m
//  Objc-Trip
//
//  Created by Binhuang on 2022/4/11.
//

#import "NSArray+GCD.h"



@implementation NSArray (GCD)

-(BOOL)isOrderedBySteps:(NSString *)steps{
    NSArray *arr = [steps componentsSeparatedByString:@"="];
    NSMutableArray *nums = [@[] mutableCopy];
    for(NSString *item in arr){
        [nums addObject:[NSNumber numberWithInteger:[item intValue]]];
    }
    for(id item in self){
        if([nums containsObject:item]){
            [nums removeObjectAtIndex:0];
        }
    }
    return nums.count == 0;
}

-(BOOL)isRandomBySteps:(NSString *)steps{
    NSArray *arr = [steps componentsSeparatedByString:@"="];
    NSMutableArray *nums = [@[] mutableCopy];
    for(NSString *item in arr){
        [nums addObject:[NSNumber numberWithInteger:[item intValue]]];
    }
    NSArray *numArr = [nums copy];
    
    NSComparator cmp = ^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 intValue] - [obj2 intValue];
    };
    NSArray *orderedArr = [numArr sortedArrayUsingComparator:cmp];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self in %@", numArr];
    NSArray *orderedArr2 = [[self filteredArrayUsingPredicate:predicate] sortedArrayUsingComparator:cmp];;
    return [orderedArr isEqual:orderedArr2];
}

@end
