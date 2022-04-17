//
//  BlockLeakTestViewController.h
//  Objc-Trip
//
//  Created by binhuang on 2022/4/15.
//

#import "DeallocController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BlockLeakTestViewController : DeallocController
@property (nonatomic,copy) NSString *testcase;
@end

NS_ASSUME_NONNULL_END
