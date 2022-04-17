//
//  MenuSection.h
//  Objc-Journey
//
//  Created by binhuang on 2022/4/7.
//

#import <Foundation/Foundation.h>
#import "MenuItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface MenuSection : NSObject

@property (nonatomic, retain) NSString *sectionName;
@property (nonatomic, retain) NSArray<MenuItem *> *items;

-(instancetype)initWithSectionName:(NSString *)sectionName items:(NSArray<MenuItem *> *)items;

@end

NS_ASSUME_NONNULL_END
