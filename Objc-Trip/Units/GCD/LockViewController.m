//
//  LockViewController.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/10.
//

#import "LockViewController.h"

@interface LockViewController ()

@end

@implementation LockViewController{
    NSMutableArray * _tmpArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)testSynchronized{
    _tmpArray = [NSMutableArray arrayWithCapacity:0];
    [self outputArray:@[@[@1,@2,@3],@[@4,@5,@6]]];
}

-(NSMutableArray *)outputArray:(NSArray *)mutArray{
    @synchronized(mutArray) {
        for (int i = 0;i< mutArray.count ; i++) {
            if ([mutArray[i] isKindOfClass:[NSArray class]]) {
                [self outputArray:mutArray[i]];
            }else{
                NSLog(@">>> %@",mutArray[i]);
                [_tmpArray addObject:mutArray[i]];
            }
        }
    }
    
    return _tmpArray;
}

@end
