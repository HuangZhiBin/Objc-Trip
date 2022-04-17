//
//  MenuItem.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/7.
//

#import "MenuItem.h"

@implementation MenuItem

-(instancetype)initWithTitle:(NSString *)title vcName:(NSString *)vcName{
    self = [super init];
    if(self){
        _title = title;
        _vcName = vcName;
    }
    return self;
}

@end
