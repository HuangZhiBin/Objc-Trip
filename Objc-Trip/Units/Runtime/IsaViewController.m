//
//  IsaViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/24.
//

#import "IsaViewController.h"
#import <objc/runtime.h>

// DIVIDE

@interface Animal: NSObject

-(void)doAnimal;

@end

@implementation Animal

-(void)doAnimal{
    
}

@end

// DIVIDE

@interface Fish: Animal

-(void)doFish;

@end

@implementation Fish

-(void)doFish{
    
}

@end

// DIVIDE

@interface Catfish: Fish

-(void)doCatfish;

@end

@implementation Catfish

-(void)doCatfish{
    
}

@end

// DIVIDE

@interface IsaViewController ()

@end

@implementation IsaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)testIsa{
    Catfish *catfish = [Catfish new];
    Class isa = [self getIsa:catfish];
    NSAssert([NSStringFromClass(isa) isEqualToString:@"Catfish"], @"");
    Class isa2 = [self getIsa:isa];
    NSAssert([NSStringFromClass(isa2) isEqualToString:@"Catfish"], @"");
}

-(Class)getIsa:(id)obj{
    return object_getClass(obj);
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
