//
//  InfiniteScrollViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/20.
//

#import "InfiniteScrollViewController.h"

@interface InfiniteScrollViewController ()<UIScrollViewDelegate>
@end

@implementation InfiniteScrollViewController{
    UIScrollView *scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self testRunMode];
}

-(void)testRunMode{
    NSTimer *timer = [NSTimer timerWithTimeInterval:2
                                             target:self
                                           selector:@selector(handle)
                                           userInfo:nil
                                            repeats:NO];
    // INFO: NSDefaultRunLoopMode的Timer会在拖拽后执行
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    // INFO: 修改加入runloop的mode，或者在子线程中加入runloop
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 20 * 100);
    for (int i = 0; i < 100; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 20 * i, self.view.bounds.size.width, 20)];
        CGFloat r = arc4random_uniform(255) / 255.0;
        CGFloat g = arc4random_uniform(255) / 255.0;
        CGFloat b = arc4random_uniform(255) / 255.0;
        view.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
        [scrollView addSubview:view];
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:scrollView];
}

- (void)handle {
    // INFO: 拖拽后Timer仍会执行
    [scrollView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
