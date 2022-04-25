//
//  DebuggerView.m
//  Objc-Trip
//
//  Created by Binhuang on 2022/4/11.
//

#import "DebuggerView.h"
#import "SVProgressHUD.h"


#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define LINE_WIDTH SCREEN_WIDTH-60

@interface DebuggerView() <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray<NSString *> *codes;
@property (nonatomic, copy) NSString* method;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *prevBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, copy) DebuggerViewBlock onPrev;
@property (nonatomic, copy) DebuggerViewBlock onNext;
@property (nonatomic, strong) UILabel *stateLabel;
@end

@implementation DebuggerView{
    NSInteger _count,_index;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

+(void)sendExecResult:(BOOL)isSuccess{
    if(isSuccess){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DebuggerViewNotificationSuccess" object:nil];
        NSLog(@"sdfsdfsf");
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DebuggerViewNotificationFail" object:nil];
    }
}

-(void)updateWithCodes:(NSArray<NSString *> *)codes method:(NSString*)method index:(NSInteger)index count:(NSInteger)count isWait:(BOOL)isWait{
    _codes = codes;
    _method = method;
    
    _count = count;
    _index = index;
    
    _label.text = [NSString stringWithFormat:@"(%ld/%ld) %@", index + 1, count, method];
    [_tableView setContentOffset:CGPointMake(0,0) animated:NO];
    [_tableView reloadData];
    [_tableView layoutIfNeeded];
    [_tableView setContentOffset:CGPointMake(0,0) animated:NO];
    
    if(!isWait){
        [_stateLabel setHidden:YES];
        [self setButtonState:YES];
        
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD setMaximumDismissTimeInterval:1];
        [SVProgressHUD showSuccessWithStatus:@"Exec success"];
    }
    else{
        [_stateLabel setHidden:NO];
        
        [self setButtonState:NO];
        
        _stateLabel.text = @"  执行中……";
        _stateLabel.backgroundColor = UIColor.grayColor;
    }
}

-(void)didFinishExec{
    [self setButtonState:YES];
    _stateLabel.text = @"  执行成功";
    _stateLabel.backgroundColor = [UIColor colorWithRed:60/255.0f green:146/255.0f blue:77/255.0f alpha:1];
}

-(void)didFailExec{
    [self setButtonState:YES];
    _stateLabel.text = @"  执行失败";
    _stateLabel.backgroundColor = UIColor.systemPinkColor;
}

-(void)setButtonState:(BOOL)enable{
    if(enable){
        [_prevBtn setEnabled:YES];
        [_closeBtn setEnabled:YES];
        [_nextBtn setEnabled:YES];
        [_prevBtn setAlpha:1];
        [_closeBtn setAlpha:1];
        [_nextBtn setAlpha:1];
    }
    else{
        [_prevBtn setEnabled:NO];
        [_closeBtn setEnabled:NO];
        [_nextBtn setEnabled:NO];
        [_prevBtn setAlpha:0.6];
        [_closeBtn setAlpha:0.6];
        [_nextBtn setAlpha:0.6];
    }
    
    if(_count == _index + 1){
        [_nextBtn setEnabled:NO];
        [_nextBtn setAlpha:0.6];
    }
    
    if(_index == 0){
        [_prevBtn setEnabled:NO];
        [_prevBtn setAlpha:0.6];
    }
}

-(instancetype)initWithPrev:(DebuggerViewBlock)prevBlock next:(DebuggerViewBlock)nextBlock{
    if([self init]){
        
        _onPrev = prevBlock;
        _onNext = nextBlock;
        
        self.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.9];
        
        //获取状态栏的高度
        CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        NSLog(@"状态栏高度：%f",statusHeight);
        //获取导航栏的高度
        CGFloat navHeight = [[UINavigationController alloc] init].navigationBar.frame.size.height;
        NSLog(@"导航栏高度：%f",navHeight);
        
        UITabBarController *tabBarVC = [[UITabBarController alloc] init];
        CGFloat tabBarHeight = tabBarVC.tabBar.frame.size.height;
        
        CGFloat viewY = statusHeight + navHeight;
        CGFloat viewHeight = [[UIScreen mainScreen] bounds].size.height - viewY  - 10;
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH,  SCREEN_HEIGHT);
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(10, viewY, [[UIScreen mainScreen] bounds].size.width - 10 * 2, 22)];
        _label.textColor = UIColor.blackColor;
        _label.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:_label];
        
        //初始化，当然还有其他初始方法，不赘述了
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, viewY + 40, [[UIScreen mainScreen] bounds].size.width - 10 * 2, viewHeight - tabBarHeight - 70)];
        _tableView.showsVerticalScrollIndicator = YES;
        //设置代理
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsSelection = NO;
        //界面添加
        [self addSubview:_tableView];
        //设置尺寸，当然也可以通过masonry之类的添加约束
        //各种属性设置
        //分割线(无分割线）
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //背景颜色
        _tableView.backgroundColor = [UIColor colorWithRed:32/255.0 green:33/255.0 blue:36/255.0 alpha:1];
//        _tableView.backgroundColor = [UIColor colorWithRed:41/255.0 green:42/255.0 blue:49/255.0 alpha:1];
//        _tableView.backgroundColor = [UIColor colorWithRed:37/255.0 green:32/255.0 blue:35/255.0 alpha:1];
        
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, viewY + 40, _tableView.frame.size.width, 24)];
        _stateLabel.backgroundColor = UIColor.grayColor;
        _stateLabel.textColor = UIColor.whiteColor;
        _stateLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_stateLabel];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:28]];
        [btn setTitle:@"×" forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2 - 20, 50.0f);
        btn.backgroundColor = [UIColor systemPinkColor];
        self.closeBtn = btn;
        
        [self.closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeBtn];
        self.closeBtn.frame = CGRectMake(80, _tableView.frame.origin.y + _tableView.frame.size.height, SCREEN_WIDTH - 160, self.closeBtn.frame.size.height);
        
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
            [btn setTitle:@"←" forState:UIControlStateNormal];
            btn.frame = CGRectMake(10, self.closeBtn.frame.origin.y, 70, 50.0f);
            btn.backgroundColor = [UIColor orangeColor];
            [btn addTarget:self action:@selector(prev) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            self.prevBtn = btn;
        }
        
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
            [btn setTitle:@"→" forState:UIControlStateNormal];
            btn.frame = CGRectMake(self.closeBtn.frame.origin.x+self.closeBtn.frame.size.width, self.closeBtn.frame.origin.y, 70, 50.0f);
            btn.backgroundColor = [UIColor orangeColor];
            [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            self.nextBtn = btn;
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveExecSuccess:) name:@"DebuggerViewNotificationSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveExecFail:) name:@"DebuggerViewNotificationFail" object:nil];
     
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)receiveExecSuccess:(NSNotification*)noti{
    [self didFinishExec];
}

-(void)receiveExecFail:(NSNotification*)noti{
    [self didFailExec];
}

-(void)prev{
    _onPrev();
}

-(void)next{
    _onNext();
}

-(void)close{
//    [self removeFromSuperview];
    [self setHidden:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 10)];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 10)];
    return headerView;
}

//每个section有几个单元格
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _codes.count;
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
    NSString *line = _codes[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    NSString *realCode = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([realCode hasPrefix:@"// DIVIDE"]){
        cell.backgroundColor = [UIColor colorWithRed:21/255.0 green:23/255.0 blue:26/255.0 alpha:1];
        line = @"";
    }
    
    else if([realCode hasPrefix:@"// INFO:"]){
        cell.textLabel.textColor = UIColor.greenColor;
    }
    else if([realCode hasPrefix:@"// QUIZ:"]){
        cell.textLabel.textColor = [UIColor colorWithRed:255/255.0f green:73/255.0f blue:41/255.0f alpha:1];;
    }
    else if([realCode hasPrefix:@"//"] || [realCode hasPrefix:@"/*"]){
        cell.textLabel.textColor = [UIColor.whiteColor colorWithAlphaComponent:0.5];
    }
    else if([line containsString:@"NSAssert("]){
        cell.textLabel.textColor = UIColor.orangeColor;
    }
    else if([line containsString:@"#import"]){
        cell.textLabel.textColor = [UIColor.whiteColor colorWithAlphaComponent:0.5];
    }
    else if([line containsString:@"@interface"]){
        cell.textLabel.textColor = UIColor.cyanColor;
    }
    else if([line containsString:@"@implementation"]){
        cell.textLabel.textColor = UIColor.cyanColor;
    }
    else if([line containsString:@"@end"]){
        cell.textLabel.textColor = UIColor.cyanColor;
    }
    else if([line containsString:@"@property"]){
        cell.textLabel.textColor = [UIColor colorWithRed:143/255.0f green:107/255.0f blue:188/255.0f alpha:1];
    }
    else{
        cell.textLabel.textColor = UIColor.whiteColor;
    }
    if([line containsString:@"SafeExit("]){
        line = [line stringByReplacingOccurrencesOfString:@"SafeExit(" withString:@"// Crash: 执行下面的代码将会闪退##"];
        line = [line substringToIndex:[line rangeOfString:@"##"].location];
        cell.textLabel.textColor = UIColor.systemPinkColor;
    }
    [self setLabelSpace:cell.textLabel withValue:line withFont:cell.textLabel.font];
    CGFloat height = [self getSpaceLabelHeight:line withFont:[UIFont systemFontOfSize:12] withWidth:LINE_WIDTH];
    cell.textLabel.frame = CGRectMake(cell.textLabel.frame.origin.x, cell.textLabel.frame.origin.y, LINE_WIDTH, height);
    return cell;
}

-(NSDictionary*)dictForText:(UIFont*)font{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 4;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    return dic;
}

-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:[self dictForText:font]];
    label.attributedText = attributeStr;
}

-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[self dictForText:font] context:nil].size;
    return size.height + 4;
}
//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *line = _codes[indexPath.row];
    CGFloat height = [self getSpaceLabelHeight:line withFont:[UIFont systemFontOfSize:12] withWidth:LINE_WIDTH];
    return height;
}
//点击单元格触发的事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"click=%ld", indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
