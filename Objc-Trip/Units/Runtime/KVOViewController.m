//
//  KVOViewController.m
//  Objc-Trip
//
//  Created by binhuang on 2022/4/26.
//

#import "KVOViewController.h"

@interface Person : NSObject

@property (nonatomic,assign) int age;

-(void)changeAge:(int)age;
-(void)changeLevel:(int)level;

-(int)getLevel;

@end

@implementation Person{
    int _level;
}

-(void)changeAge:(int)age{
    _age = age;
}

-(void)changeLevel:(int)level{
    _level = level;
}

-(int)getLevel{
    return _level;
}

@end

@interface KVOViewController ()

@property (nonatomic,strong) Person *person;

@end

@implementation KVOViewController{
    BOOL kovObserved;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.person = [Person new];
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.person addObserver:self forKeyPath:@"age" options:options context:nil];
}

-(void)groupModifyValue{}

-(void)testModifyIvar1{
    kovObserved = NO;
    [self.person changeAge:1];
    NSAssert(!kovObserved, @"直接修改成员变量不会触发KVO");
}

-(void)testModifyIvar2{
    kovObserved = NO;
    [self.person changeLevel:2];
    NSAssert(!kovObserved, @"直接修改成员变量不会触发KVO");
}

-(void)groupKOC{}

-(void)testKOC_property1{
    kovObserved = NO;
    [self.person setValue:@1 forKey:@"age"];
    NSAssert(self.person.age == 1, @"KVC可以修改");
    NSAssert(kovObserved, @"age为属性，且key为age（无下划线）会触发KVO");
}

-(void)testKOC_property2{
    kovObserved = NO;
    [self.person setValue:@2 forKey:@"_age"];
    NSAssert(self.person.age == 2, @"KVC可以修改");
    NSAssert(!kovObserved, @"不会触发KVO");
}

-(void)testKOC_ivar1{
    kovObserved = NO;
    [self.person setValue:@1 forKey:@"level"];
    NSAssert([self.person getLevel] == 1, @"KVC可以修改");
    NSAssert(!kovObserved, @"不会触发KVO");
}

-(void)testKOC_ivar2{
    kovObserved = NO;
    [self.person setValue:@2 forKey:@"_level"];
    NSAssert([self.person getLevel] == 2, @"KVC可以修改");
    NSAssert(!kovObserved, @"不会触发KVO");
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    kovObserved = YES;
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
