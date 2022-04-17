//
//  MenuSection.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/7.
//

#import "MenuSection.h"

@implementation MenuSection

-(instancetype)initWithSectionName:(NSString *)sectionName items:(NSArray<MenuItem *> *)items{
    self = [super init];
    if(self){
        _sectionName = sectionName;
        _items = items;
    }
    return self;
}

@end
