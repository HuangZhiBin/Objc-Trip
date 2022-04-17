//
//  BaseViewController.m
//  Objc-Journey
//
//  Created by binhuang on 2022/4/7.
//

#import "BaseViewController.h"
#import <objc/runtime.h>
#import "DebuggerView.h"
#import "SVProgressHUD.h"

@interface BaseViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, strong) NSArray<NSString *> *menus;
@end

@implementation BaseViewController{
    NSArray<NSString *> *lines;
    NSMutableDictionary *redirectDict;
    
    DebuggerView *debuggerView;
}
@synthesize menus;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [BaseUtil startListeningAutoRelease];
    
    // Do any additional setup after loading the view.
    menus = [self getAllMethods];
    redirectDict = [NSMutableDictionary dictionaryWithDictionary:[self redirect]];
    [self configUI];
    
    __weak BaseViewController *vc = self;
    debuggerView = [[DebuggerView alloc] initWithPrev:^{
        [vc goPrev];
    } next:^{
        [vc goNext];
    }];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:debuggerView];
    [debuggerView setHidden:YES];
}

-(void)dealloc{
    [debuggerView removeFromSuperview];
    [BaseUtil stopListeningAutoRelease];
}

-(NSDictionary*)redirect{
    return @{};
}

-(NSArray*)validMenus{
    NSMutableArray *arr = [NSMutableArray array];
    for(NSString *menu in menus){
        if(![menu hasPrefix:@"group"]){
            [arr addObject:menu];
        }
    }
    return [arr copy];
}

-(NSString *)getPrev:(NSString*)curMethod{
    NSInteger idx = [[self validMenus] indexOfObject:curMethod];
    if(idx > 0){
        return [self validMenus][idx - 1];
    }
    return nil;
}

-(NSString *)getNext:(NSString*)curMethod{
    NSInteger idx = [[self validMenus] indexOfObject:curMethod];
    if(idx < [self validMenus].count - 1){
        return [self validMenus][idx + 1];
    }
    return nil;
}

-(void)goPrev{
    NSString *method = [self getPrev:menus[self.selectedRow]];
    if(!method){
        return;
    }
    self.selectedRow = [menus indexOfObject:method];
    [self executeMethod];
}

-(void)goNext{
    NSString *method = [self getNext:menus[self.selectedRow]];
    if(!method){
        return;
    }
    self.selectedRow = [menus indexOfObject:method];
    [self executeMethod];
}

-(NSArray *)loadCodesForClassName:(NSString*)className method:(NSString *)method{
    //NSStringFromClass([self class])
    // Document路径
    NSString *codesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *codePath = [NSString stringWithFormat:@"%@/code_files/%@.m", codesPath, className];
    NSError *error = nil;
    NSString *textFieldContents=[NSString stringWithContentsOfFile:codePath encoding:NSUTF8StringEncoding error:&error];
    lines = [textFieldContents componentsSeparatedByString:@"\n"];
    
    NSMutableArray *validLines = [NSMutableArray array];
    BOOL isStart = NO;
    BOOL isFileStart = NO;
    for(NSString *line in lines){
        if([line hasPrefix:@"#import"]){
            isStart = YES;
            isFileStart = YES;
        }
        else if([line isEqualToString:@"@end"]){
            isStart = YES;
        }
        else if([line containsString:@"#pragma mark - Navigation"]){
            isStart = NO;
        }
        else if([line containsString:@"(void)prepareForSegue"]){
            isStart = NO;
        }
        else if([line hasPrefix:@"-"] && [line containsString:@"(void)group"]){
            isStart = NO;
        }
        else if([line hasPrefix:@"-"] && [line containsString:@"(void)redirect"]){
            isStart = NO;
        }
        else if([line hasPrefix:@"-"] && [line containsString:@"(void)test"]){
            if([line containsString:[NSString stringWithFormat:@"(void)%@{",method]]){
                isStart = YES;
            }
            else{
                isStart = NO;
            }
        }
        else if(([line hasPrefix:@"-"] || [line hasPrefix:@"+"]) && [line containsString:@"("] && [line containsString:@")"]){
            isStart = YES;
        }
        
        if(isStart && isFileStart){
            [validLines addObject:line];
        }
    }
    
    return [validLines copy];
}

-(void)configUI{
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
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}

//每个section有几个单元格
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menus.count;
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
    NSString *item = menus[indexPath.row];
    
    cell.textLabel.textColor = UIColor.blackColor;
    if([item hasPrefix:@"group"]){
        cell.textLabel.text = [item substringFromIndex:5];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
        cell.textLabel.textColor = UIColor.magentaColor;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else if([item hasSuffix:@"_"]){
        cell.textLabel.text = [item substringToIndex:[item length]-1];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = UIColor.blackColor;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    else{
        cell.textLabel.text = item;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = UIColor.blackColor;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([menus[indexPath.row] hasPrefix:@"group"]){
        return;
    }
    
    self.selectedRow = indexPath.row;
    [self executeMethod];
}

-(void)executeMethod{
    NSString *method = menus[self.selectedRow];
    NSArray *codeLines;
    if(![[self redirect].allKeys containsObject:method]){
        codeLines = [self loadCodesForClassName:NSStringFromClass([self class]) method:method];
    }
    else{
        NSString *className = [self redirect][method][0];
        NSString *func = [self redirect][method][1];
        codeLines = [self loadCodesForClassName:className method:func];
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(method)];
#pragma clang diagnostic pop
    
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setMaximumDismissTimeInterval:1];
    [SVProgressHUD showSuccessWithStatus:@"Exec success"];
    
    [debuggerView setHidden:NO];
    [debuggerView updateWithCodes:codeLines method:method index:[[self validMenus] indexOfObject:method] count:[self validMenus].count];
    
//    DebuggerView *debuggerView = [[DebuggerView alloc] initWithCodes:codeLines method:method];
//    debuggerView.delegate = self;
//    [self.view addSubview:debuggerView];
    
//    [self executeMethod];
}



/* 获取对象的所有方法 */
-(NSArray<NSString *> *)getAllMethods
{
    unsigned int methodCount =0;
    Method* methodList = class_copyMethodList([self class],&methodCount);
    NSMutableArray<NSString *> *methodsArray = [NSMutableArray arrayWithCapacity:methodCount];
    
    for(int i=0;i<methodCount;i++)
    {
        Method temp = methodList[i];
        const char* name_s =sel_getName(method_getName(temp));
        //        int arguments = method_getNumberOfArguments(temp);
        //        const char* encoding =method_getTypeEncoding(temp);
        //        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s],
        //              arguments,
        //              [NSString stringWithUTF8String:encoding]);
        if([[NSString stringWithUTF8String:name_s] hasPrefix:@"test"]||[[NSString stringWithUTF8String:name_s] hasPrefix:@"group"]){
            [methodsArray addObject:[NSString stringWithUTF8String:name_s]];
        }
    }
    free(methodList);
    return [methodsArray copy];
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
