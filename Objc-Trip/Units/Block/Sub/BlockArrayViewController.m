//
//  BlockArrayViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/21.
//

#import "BlockArrayViewController.h"

@interface BlockArrayViewController ()
@property (nonatomic, strong) NSMutableArray *mArray;
@end

@implementation BlockArrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (NSMutableArray *)mArray{
    if (!_mArray) _mArray = [NSMutableArray arrayWithCapacity:1];
    return _mArray;
}
- (void)test {
    
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"1",@"2", nil];
    self.mArray = arr;

    void (^kcBlock)(void) = ^{
        [arr addObject:@"3"];
        [self.mArray addObject:@"4"];
        
        BOOL re1 = [[arr copy] isEqual:@[ @"1", @"2", @"5", @"6", @"3"  ]];
        NSAssert(re1, @"");
        
        BOOL re2 = [[self.mArray copy] isEqual:@[ @"4"  ]];
        NSAssert(re2, @"");
    };
    [arr addObject:@"5"];
    [self.mArray addObject:@"6"];
    
    arr = nil;
    self.mArray = nil;
    
    kcBlock();
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
