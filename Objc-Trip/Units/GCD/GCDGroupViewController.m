//
//  GCDGroupViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/16.
//

#import "GCDGroupViewController.h"
#import "GCDLogger.h"


@interface GCDGroupViewController ()

@end

@implementation GCDGroupViewController{
    GCDLogger *logger;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    logger = [[GCDLogger alloc] init];
}

-(wait)testGroupNotify{
    [logger reset];
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    // 创建一个group
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, globalQueue, ^{
        [self->logger addStep:1];
    });
    
    
    dispatch_group_async(group, globalQueue, ^{
        [self->logger addStep:2];
    });
    
    dispatch_group_async(group, globalQueue, ^{
        [self->logger addStep:3];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self->logger check:^(NSArray * _Nonnull steps) {
            NSAssert([steps isRandomBySteps:@"1=2=3"], @"步骤123随机顺序完成");
            waitSuccess;
        } delay:0];
    });
    
    returnWait;
}

-(wait)testGroupWait{
    [logger reset];
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    // 创建一个group
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, globalQueue, ^{
        [self->logger addStep:1];
    });
    
    dispatch_group_async(group, globalQueue, ^{
        [self->logger addStep:2];
    });
    
    dispatch_group_async(group, globalQueue, ^{
        [self->logger addStep:3];
    });
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    [self->logger addStep:4];
    
    [logger check:^(NSArray * _Nonnull steps) {
        NSAssert([steps isRandomBySteps:@"1=2=3"], @"步骤123随机顺序完成");
        NSAssert([[steps lastObject] isEqual:@4], @"步骤4最后执行");
        waitSuccess;
    } delay:0];
    
    returnWait;
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
