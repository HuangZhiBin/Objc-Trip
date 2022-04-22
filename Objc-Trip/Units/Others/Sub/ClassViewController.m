//
//  ClassViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/21.
//

#import "ClassViewController.h"
#import "BaseUtil.h"

@interface LGPerson : NSObject
@property (nonatomic, retain) NSString *kc_name;
- (void)saySomething;
@end

@implementation LGPerson
- (void)saySomething{
    NSLog(@"%s",__func__);
//    SafeExit();
    NSLog(@"%@",self.kc_name);
}
@end

@interface ClassViewController ()

@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)test{
    LGPerson *person = [LGPerson alloc];
    [person saySomething];
    
    Class cls = [LGPerson class];
    void  *kc = &cls;
    [(__bridge id)kc saySomething];
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
