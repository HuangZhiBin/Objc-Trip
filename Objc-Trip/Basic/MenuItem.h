//
//  MenuItem.h
//  Objc-Journey
//
//  Created by binhuang on 2022/4/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenuItem : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *vcName;

-(instancetype)initWithTitle:(NSString *)title vcName:(NSString *)vcName;

@end

NS_ASSUME_NONNULL_END
