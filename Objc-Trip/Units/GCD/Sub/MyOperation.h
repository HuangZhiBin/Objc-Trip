//
//  MyOperation.h
//  Objc-Trip
//
//  Created by binhuang on 2022/4/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MyOperationBlock) (void);
@interface MyOperation : NSOperation

-(instancetype)initWith:(MyOperationBlock)block;

@end

NS_ASSUME_NONNULL_END
