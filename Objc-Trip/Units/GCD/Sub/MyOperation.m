//
//  MyOperation.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/17.
//

#import "MyOperation.h"

@interface MyOperation ()
@property (nonatomic,copy) MyOperationBlock block;
@end

@implementation MyOperation

-(instancetype)initWith:(MyOperationBlock)block{
    self = [super init];
    if(self){
        _block = block;
    }
    return self;
}

-(void)main{
    self.block();
}

@end
