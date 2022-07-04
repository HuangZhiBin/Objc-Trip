//
//  ViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/6/17.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(NSString*)pdd_pasteboard {
    __block NSString *result = nil;
    dispatch_queue_t concurrentQueue = dispatch_queue_create("test", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        result = [[UIPasteboard generalPasteboard] string];
    });
    int currentTime = 0;
    while(currentTime < 5 && result == nil){
        sleep(1);
    }
    
    sel
    
    return result;
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
