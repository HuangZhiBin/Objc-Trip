//
//  ViewController.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/7.
//

#import "ViewController.h"
#import "MenuSection.h"
#import "BaseUtil.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@end

@implementation ViewController{
    NSArray<MenuSection *> *menus;
}

-(void)viewDidDisappear:(BOOL)animated{
//    [BaseUtil stopListeningAutoRelease];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [BaseUtil startListeningAutoRelease];
    
    self.title = @"Objc Trip";
    // Do any additional setup after loading the view.
    
    menus =
    @[
        [[MenuSection alloc] initWithSectionName:@"OC基础" items:@[
            [[MenuItem alloc] initWithTitle:@"static" vcName:@"StaticViewController"],
            [[MenuItem alloc] initWithTitle:@"+load" vcName:@"LoadViewController"],
            [[MenuItem alloc] initWithTitle:@"+initialize" vcName:@"InitializeViewController"],
        ]],
        [[MenuSection alloc] initWithSectionName:@"Runtime" items:@[
            [[MenuItem alloc] initWithTitle:@"MsgSend" vcName:@"MsgSendViewController"],
            [[MenuItem alloc] initWithTitle:@"ivar/propertyList" vcName:@"IvarViewController"],
            [[MenuItem alloc] initWithTitle:@"KVO" vcName:@"KVOViewController"],
        ]],
        [[MenuSection alloc] initWithSectionName:@"ARC" items:@[
            [[MenuItem alloc] initWithTitle:@"RetainCount" vcName:@"RetainCountViewController"],
            [[MenuItem alloc] initWithTitle:@"Autorelease" vcName:@"AutoreleaseViewController"],
            [[MenuItem alloc] initWithTitle:@"Weak" vcName:@"WeakViewController"],
            [[MenuItem alloc] initWithTitle:@"Copy" vcName:@"CopyViewController"],
            [[MenuItem alloc] initWithTitle:@"CFBridge" vcName:@"CFBridgeViewController"],
        ]],
        [[MenuSection alloc] initWithSectionName:@"多线程" items:@[
            [[MenuItem alloc] initWithTitle:@"dispatch_sync_async" vcName:@"GCDViewController"],
            [[MenuItem alloc] initWithTitle:@"dispatch_set_target_queue" vcName:@"GCDSetTargetViewController"],
            [[MenuItem alloc] initWithTitle:@"dispatch_after" vcName:@"GCDAfterViewController"],
            [[MenuItem alloc] initWithTitle:@"dispatch_group" vcName:@"GCDGroupViewController"],
            [[MenuItem alloc] initWithTitle:@"dispatch_barrier" vcName:@"GCDBarrierViewController"],
            [[MenuItem alloc] initWithTitle:@"dispatch_apply" vcName:@"GCDApplyViewController"],
            [[MenuItem alloc] initWithTitle:@"dispatch_suspend_cancel" vcName:@"GCDSuspendViewController"],
            [[MenuItem alloc] initWithTitle:@"dispatch_semaphore" vcName:@"GCDSemaphoreViewController"],
            [[MenuItem alloc] initWithTitle:@"dispatch_source" vcName:@"GCDSourceViewController"],
            [[MenuItem alloc] initWithTitle:@"NSOperation" vcName:@"OperationViewController"],
        ]],
        [[MenuSection alloc] initWithSectionName:@"Block" items:@[
            [[MenuItem alloc] initWithTitle:@"Struct" vcName:@"BlockStructViewController"],
            [[MenuItem alloc] initWithTitle:@"ValueCapture" vcName:@"VarViewController"],
            [[MenuItem alloc] initWithTitle:@"BlockType" vcName:@"BlockViewController"],
            [[MenuItem alloc] initWithTitle:@"Leak" vcName:@"BlockLeakViewController"],
        ]],
        [[MenuSection alloc] initWithSectionName:@"Others" items:@[
            [[MenuItem alloc] initWithTitle:@"Others" vcName:@"OthersViewController"],
            [[MenuItem alloc] initWithTitle:@"Batch" vcName:@"BatchViewController"],
            [[MenuItem alloc] initWithTitle:@"Lock" vcName:@"LockViewController"],
            [[MenuItem alloc] initWithTitle:@"NSTimer" vcName:@"NSTimerViewController"],
            [[MenuItem alloc] initWithTitle:@"NSNotification" vcName:@"NSNotificationViewController"],
        ]],
    ];
    
    //初始化，当然还有其他初始方法，不赘述了
    _tableView = [[UITableView alloc] init];
    //设置代理
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //界面添加
    [self.view addSubview:_tableView];
    //设置尺寸，当然也可以通过masonry之类的添加约束
    [_tableView setFrame:self.view.frame];
    //各种属性设置
    //分割线(无分割线）
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //背景颜色
    _tableView.backgroundColor = [UIColor whiteColor];
}

//section数目
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return menus.count;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor whiteColor];

    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor colorWithRed:32/255.0f green:146/255.0f blue:234/255.0f alpha:1]];

    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

//每个section有几个单元格
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"size=%ld", menus[section].items.count);
//    _objc_autoreleasePoolPrint();
    return menus[section].items.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return menus[section].sectionName;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
}

//单元格具体实现
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //注意单元格的复用
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    MenuItem *item = menus[indexPath.section].items[indexPath.row];
    cell.textLabel.text = item.title;
    cell.textLabel.textColor = UIColor.blackColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
//点击单元格触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"click=%ld", indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MenuItem *item = menus[indexPath.section].items[indexPath.row];
    UIViewController *vc = [[NSClassFromString(item.vcName) alloc] init];
    vc.title = item.title;
    [self.navigationController pushViewController:vc animated:YES];
    
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


