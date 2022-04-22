//
//  SubViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/21.
//

#import "SubViewController.h"

@interface SubViewController ()

@end

@implementation SubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self performSelector:NSSelectorFromString(self.testcase)];
    
    if(self.autoPop){
        [self.navigationController popViewControllerAnimated:YES];
    }
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
