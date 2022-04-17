//
//  DebuggerView.h
//  Objc-Trip
//
//  Created by Binhuang on 2022/4/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^DebuggerViewBlock) (void);

@interface DebuggerView : UIView

+(void)sendExecResult:(BOOL)isSuccess;

-(void)updateWithCodes:(NSArray<NSString *> *)codes method:(NSString*)method index:(NSInteger)index count:(NSInteger)count isWait:(BOOL)isWait;
-(instancetype)initWithPrev:(DebuggerViewBlock)prevBlock next:(DebuggerViewBlock)nextBlock;
-(void)didFinishExec;

@end

NS_ASSUME_NONNULL_END
