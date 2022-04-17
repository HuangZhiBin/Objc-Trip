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
    
    self.title = @"Objc Journey";
    // Do any additional setup after loading the view.
    
    menus =
    @[
        [[MenuSection alloc] initWithSectionName:@"ARC" items:@[
            [[MenuItem alloc] initWithTitle:@"RetainCount" vcName:@"RetainCountViewController"],
            [[MenuItem alloc] initWithTitle:@"CFBridge" vcName:@"CFBridgeViewController"],
            [[MenuItem alloc] initWithTitle:@"Autorelease" vcName:@"AutoreleaseViewController"],
            [[MenuItem alloc] initWithTitle:@"Weak" vcName:@"WeakViewController"],
            [[MenuItem alloc] initWithTitle:@"Dealloc" vcName:@"DeallocViewController"],
            [[MenuItem alloc] initWithTitle:@"Copy" vcName:@"CopyViewController"],
        ]],
        [[MenuSection alloc] initWithSectionName:@"多线程" items:@[
            [[MenuItem alloc] initWithTitle:@"GCD" vcName:@"GCDViewController"],
            [[MenuItem alloc] initWithTitle:@"Atomic" vcName:@"AtomicViewController"],
            [[MenuItem alloc] initWithTitle:@"Lock" vcName:@"LockViewController"],
            [[MenuItem alloc] initWithTitle:@"dispatch_set_target_queue" vcName:@"GCDSetTargetViewController"],
            [[MenuItem alloc] initWithTitle:@"dispatch_after" vcName:@"GCDAfterViewController"],
            [[MenuItem alloc] initWithTitle:@"dispatch_group" vcName:@"GCDGroupViewController"],
        ]],
        [[MenuSection alloc] initWithSectionName:@"Block" items:@[
            [[MenuItem alloc] initWithTitle:@"ValueCapture" vcName:@"VarViewController"],
            [[MenuItem alloc] initWithTitle:@"BlockType" vcName:@"BlockViewController"],
            [[MenuItem alloc] initWithTitle:@"Leak" vcName:@"BlockLeakViewController"],
            
        ]],
        [[MenuSection alloc] initWithSectionName:@"Others" items:@[
            [[MenuItem alloc] initWithTitle:@"Others" vcName:@"OthersViewController"],
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


