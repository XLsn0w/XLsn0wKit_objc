/*********************************************************************************************
 *   __      __   _         _________     _ _     _    _________   __         _         __   *
 *	 \ \    / /  | |        | _______|   | | \   | |  |  ______ |  \ \       / \       / /   *
 *	  \ \  / /   | |        | |          | |\ \  | |  | |     | |   \ \     / \ \     / /    *
 *     \ \/ /    | |        | |______    | | \ \ | |  | |     | |    \ \   / / \ \   / /     *
 *     /\/\/\    | |        |_______ |   | |  \ \| |  | |     | |     \ \ / /   \ \ / /      *
 *    / /  \ \   | |______   ______| |   | |   \ \ |  | |_____| |      \ \ /     \ \ /       *
 *   /_/    \_\  |________| |________|   |_|    \__|  |_________|       \_/       \_/        *
 *                                                                                           *
 *********************************************************************************************/

#import "XLsn0wCityChooser.h"
#import "XLsn0wMacro.h"

#import "XLsn0wCityTableViewCell.h"
#import "XLsn0wCityHeaderView.h"
#import "XLsn0wCityAreaDataManager.h"
#import "XLsn0wCityLocation.h"
#import "XLsn0wCitySearchView.h"

#define KCURRENTCITYINFODEFAULTS [NSUserDefaults standardUserDefaults]

@interface XLsn0wCityChooser () <UITableViewDelegate, UITableViewDataSource, XLsn0wCityLocationDelegate> {
    NSMutableArray   *_indexMutableArray;           //存字母索引下标数组
    NSMutableArray   *_sectionMutableArray;         //存处理过以后的数组
    NSInteger        _HeaderSectionTotal;           //头section的个数
    CGFloat          _cellHeight;                   //添加的(显示区县名称)cell的高度
}

@property (nonatomic, strong) UITableView *rootTableView;
@property (nonatomic, strong) XLsn0wCityTableViewCell *cell;
@property (nonatomic, strong) XLsn0wCityHeaderView *headerView;
@property (nonatomic, strong) XLsn0wCityAreaDataManager *manager;
@property (nonatomic, strong) XLsn0wCityLocation *locationManager;
@property (nonatomic, strong) XLsn0wCitySearchView *searchView;

/** 最近访问的城市*/
@property (nonatomic, strong) NSMutableArray *historyCityMutableArray;
/** 热门城市*/
@property (nonatomic, strong) NSArray *hotCityArray;
/** 字母索引*/
@property (nonatomic, strong) NSMutableArray *characterMutableArray;
/** 所有“市”级城市名称*/
@property (nonatomic, strong) NSMutableArray *cityMutableArray;
/** 根据cityNumber在数据库中查到的区县*/
@property (nonatomic, strong) NSMutableArray *areaMutableArray;

@end

@implementation XLsn0wCityChooser

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _HeaderSectionTotal = 3;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseCityWithName:) name:JFCityTableViewCellDidChangeCityNotification object:nil];
    
    [self.view addSubview:self.rootTableView];
    self.rootTableView.tableHeaderView = self.headerView;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0.0, 0.0, 44.0, 44.0);
    [leftButton setImage:[UIImage imageNamed:@"navBackButton"] forState:(UIControlStateNormal)];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, -16.0, 0.0, 16.0);
    [leftButton addTarget:self action:@selector(backrootTableViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    
    
    [self initWithJFAreaDataManaager];
    
    _indexMutableArray = [NSMutableArray array];
    _sectionMutableArray = [NSMutableArray array];
    
    if ([KCURRENTCITYINFODEFAULTS objectForKey:@"cityData"]) {
        self.characterMutableArray = [NSKeyedUnarchiver unarchiveObjectWithData:[KCURRENTCITYINFODEFAULTS objectForKey:@"cityData"]];
        _sectionMutableArray = [NSKeyedUnarchiver unarchiveObjectWithData:[KCURRENTCITYINFODEFAULTS objectForKey:@"sectionData"]];
        [_rootTableView reloadData];
    }else {
        @WeakObj(self)
        //在子线程中异步执行汉字转拼音再转汉字耗时操作
        dispatch_queue_t serialQueue = dispatch_queue_create("com.city.www", DISPATCH_QUEUE_SERIAL);
        dispatch_async(serialQueue, ^{
            [selfWeak processData:^(id success) {
                //回到主线程刷新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self->_rootTableView reloadData];
                    selfWeak.locationManager = [[XLsn0wCityLocation alloc] init];
                    self->_locationManager.delegate = selfWeak;
                });
            }];
        });
    }
    
    self.historyCityMutableArray = [NSKeyedUnarchiver unarchiveObjectWithData:[KCURRENTCITYINFODEFAULTS objectForKey:@"historyCity"]];
}

/// 初始化数据库，获取所有“市”级城市名称
- (void)initWithJFAreaDataManaager {
    XLsn0wCityAreaDataManager *manager = [XLsn0wCityAreaDataManager shareManager];
    @WeakObj(self)
    [manager areaSqliteDBData];
    [manager cityData:^(NSMutableArray *dataArray) {
        selfWeak.cityMutableArray = dataArray;
    }];
}

/// 选择城市时调用通知函数（前提是点击cell的section < 3）
- (void)chooseCityWithName:(NSNotification *)info {
    NSDictionary *cityDic = info.userInfo;
    NSString *cityName = [[NSString alloc] init];
    if ([[cityDic valueForKey:@"cityName"] isEqualToString:@"全城"]) {
        __weak typeof(self) weakSelf = self;
        [_manager currentCity:[KCURRENTCITYINFODEFAULTS objectForKey:@"cityNumber"] currentCityName:^(NSString *name) {
            [KCURRENTCITYINFODEFAULTS setObject:name forKey:@"currentCity"];
            weakSelf.headerView.cityName = name;
            if (weakSelf.choseCityBlock) {
                weakSelf.choseCityBlock(name);
            }
        }];
    }else {
        cityName = [cityDic valueForKey:@"cityName"];
        _headerView.cityName = cityName;
        [KCURRENTCITYINFODEFAULTS setObject:[cityDic valueForKey:@"cityName"] forKey:@"currentCity"];
        
        if (self.choseCityBlock) {
            self.choseCityBlock(cityName);
        }
        [_manager cityNumberWithCity:[cityDic valueForKey:@"cityName"] cityNumber:^(NSString *cityNumber) {
            [KCURRENTCITYINFODEFAULTS setObject:cityNumber forKey:@"cityNumber"];
        }];
        
        [self historyCity:cityName];
    }
    
    //销毁通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)choseCityBlock:(XLsn0wCityChooserBlock)block {
    self.choseCityBlock = block;
}

- (NSMutableArray *)areaMutableArray {
    if (!_areaMutableArray) {
        _areaMutableArray = [NSMutableArray arrayWithObject:@"全城"];
    }
    return _areaMutableArray;
}

- (XLsn0wCityHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[XLsn0wCityHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.buttonTitle = @"选择区县";
        _headerView.cityName = [KCURRENTCITYINFODEFAULTS objectForKey:@"currentCity"] ? [KCURRENTCITYINFODEFAULTS objectForKey:@"currentCity"] : [KCURRENTCITYINFODEFAULTS objectForKey:@"locationCity"];
        
        self.manager = [XLsn0wCityAreaDataManager shareManager];
        
#pragma mark-- headerView的JFCityHeaderViewSearchBlock
        
        //获取当前城市的所有辖区
        @WeakObj(self)
        [selfWeak.headerView cityNameBlock:^(BOOL selected) {
            if (selected) {
                [selfWeak.manager areaData:[KCURRENTCITYINFODEFAULTS objectForKey:@"cityNumber"] areaData:^(NSMutableArray *areaData) {
                    [selfWeak.areaMutableArray addObjectsFromArray:areaData];
                    if (0 == (selfWeak.areaMutableArray.count % 3)) {
                        self->_cellHeight = selfWeak.areaMutableArray.count / 3 * 50;
                    }else {
                        self->_cellHeight = (selfWeak.areaMutableArray.count / 3 + 1) * 50;
                    }
                    if (self->_cellHeight > 300) {
                        self->_cellHeight = 300;
                    }
                }];
                
                
                //添加一行cell
                [selfWeak.rootTableView endUpdates];
                [selfWeak.characterMutableArray insertObject:@"*" atIndex:0];
                self->_HeaderSectionTotal = 4;
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
                [selfWeak.rootTableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                [self->_rootTableView endUpdates];
            }else {
                //清空区县名称数组
                self.areaMutableArray = nil;
                //删除一行cell
                [self->_rootTableView endUpdates];
                [self->_characterMutableArray removeObjectAtIndex:0];
                self->_HeaderSectionTotal = 3;
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
                [self.rootTableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                [self->_rootTableView endUpdates];
            }
        }];

        __weak typeof(self) weakSelf = self;
        [_headerView beginSearchBlock:^{
            
            [weakSelf.view addSubview:weakSelf.searchView];
        }];
        
        [_headerView didSearchBlock:^{
            [weakSelf deleteSearchView];
        }];
        
        [_headerView searchResultBlock:^(NSString *result) {
            [weakSelf.manager searchCityData:result result:^(NSMutableArray *result) {
                if ([result count] > 0) {
                    self->_searchView.backgroundColor = [UIColor whiteColor];
                    self->_searchView.resultMutableArray = result;
                }
            }];
        }];
    }
    return _headerView;
}

- (XLsn0wCitySearchView *)searchView {
    if (!_searchView) {
        CGRect frame = [UIScreen mainScreen].bounds;
        _searchView = [[XLsn0wCitySearchView alloc] initWithFrame:CGRectMake(0, 104, frame.size.width, frame.size.height  - 104)];
        _searchView.backgroundColor = [UIColor colorWithRed:155 / 255.0 green:155 / 255.0 blue:155 / 255.0 alpha:0.5];
        
        __weak typeof(self) weakSelf = self;
        [_searchView resultBlock:^(NSDictionary *cityData) {
            [KCURRENTCITYINFODEFAULTS setObject:[cityData valueForKey:@"city"] forKey:@"currentCity"];
            [KCURRENTCITYINFODEFAULTS setObject:[cityData valueForKey:@"city_number"] forKey:@"cityNumber"];
            
            if (weakSelf.choseCityBlock) {
                weakSelf.choseCityBlock([cityData valueForKey:@"city"]);
            }
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
            [self historyCity:[cityData valueForKey:@"city"]];
        }];
        
        [_searchView touchViewBlock:^{
            [weakSelf.headerView cancelSearch];
        }];
    }
    return _searchView;
}

/// 移除搜索界面
- (void)deleteSearchView {
    [_searchView removeFromSuperview];
    _searchView = nil;
}

- (NSMutableArray *)historyCityMutableArray {
    if (!_historyCityMutableArray) {
        _historyCityMutableArray = [[NSMutableArray alloc] init];
    }
    return _historyCityMutableArray;
}

- (NSArray *)hotCityArray {
    if (!_hotCityArray) {
        _hotCityArray = @[@"北京市", @"上海市", @"广州市", @"深圳市", @"武汉市", @"天津市", @"西安市", @"南京市", @"杭州市", @"成都市", @"重庆市"];
    }
    return _hotCityArray;
}

- (NSMutableArray *)characterMutableArray {
    if (!_characterMutableArray) {
        _characterMutableArray = [NSMutableArray arrayWithObjects:@"!", @"#", @"$", nil];
    }
    return _characterMutableArray;
}


/// 汉字转拼音再转成汉字
-(void)processData:(void (^) (id))success {
    for (int i = 0; i < _cityMutableArray.count; i ++) {
        NSString *str = _cityMutableArray[i]; //一开始的内容
        if (str.length) {  //下面那2个转换的方法一个都不能少
            NSMutableString *ms = [[NSMutableString alloc] initWithString:str];
            //汉字转拼音
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            }
            //拼音转英文
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                //字符串截取第一位，并转换成大写字母
                NSString *firstStr = [[ms substringToIndex:1] uppercaseString];
                //如果不是字母开头的，转为＃
                BOOL isLetter = [self matchLetter:firstStr];
                if (!isLetter)
                    firstStr = @"#";
                
                //如果还没有索引
                if (_indexMutableArray.count <= 0) {
                    //保存当前这个做索引
                    [_indexMutableArray addObject:firstStr];
                    //用这个字母做字典的key，将当前的标题保存到key对应的数组里面去
                    NSMutableArray *array = [NSMutableArray arrayWithObject:str];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:array,firstStr, nil];
                    [_sectionMutableArray addObject:dic];
                }else{
                    //如果索引里面包含了当前这个字母，直接保存数据
                    if ([_indexMutableArray containsObject:firstStr]) {
                        //取索引对应的数组，保存当前标题到数组里面
                        NSMutableArray *array = _sectionMutableArray[0][firstStr];
                        [array addObject:str];
                        //重新保存数据
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:array,firstStr, nil];
                        [_sectionMutableArray addObject:dic];
                    }else{
                        //如果没有包含，说明是新的索引
                        [_indexMutableArray addObject:firstStr];
                        //用这个字母做字典的key，将当前的标题保存到key对应的数组里面去
                        NSMutableArray *array = [NSMutableArray arrayWithObject:str];
                        NSMutableDictionary *dic = _sectionMutableArray[0];
                        [dic setObject:array forKey:firstStr];
                        [_sectionMutableArray addObject:dic];
                    }
                }
            }
        }
    }
    
    //将字母排序
    NSArray *compareArray = [[_sectionMutableArray[0] allKeys] sortedArrayUsingSelector:@selector(compare:)];
    _indexMutableArray = [NSMutableArray arrayWithArray:compareArray];
    
    //判断第一个是不是字母，如果不是放到最后一个
    BOOL isLetter = [self matchLetter:_indexMutableArray[0]];
    if (!isLetter) {
        //获取数组的第一个元素
        NSString *firstStr = [_indexMutableArray firstObject];
        //移除第一项元素
        [_indexMutableArray removeObjectAtIndex:0];
        //插入到最后一个位置
        [_indexMutableArray insertObject:firstStr atIndex:_indexMutableArray.count];
    }
    
    [self.characterMutableArray addObjectsFromArray:_indexMutableArray];
    NSData *cityData = [NSKeyedArchiver archivedDataWithRootObject:self.characterMutableArray];
    NSData *sectionData = [NSKeyedArchiver archivedDataWithRootObject:_sectionMutableArray];
    
    //拼音转换太耗时，这里把第一次转换结果存到单例中
    [KCURRENTCITYINFODEFAULTS setValue:cityData forKey:@"cityData"];
    [KCURRENTCITYINFODEFAULTS setObject:sectionData forKey:@"sectionData"];
    success(@"成功");
}

#pragma mark - 匹配是不是字母开头
- (BOOL)matchLetter:(NSString *)str {
    //判断是否以字母开头
    NSString *ZIMU = @"^[A-Za-z]+$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    if ([regextestA evaluateWithObject:str] == YES)
        return YES;
    else
        return NO;
}

- (void)backrootTableViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)rootTableView {
    if (!_rootTableView) {
        _rootTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _rootTableView.delegate = self;
        _rootTableView.dataSource = self;
        _rootTableView.sectionIndexColor = [UIColor colorWithRed:0/255.0f green:132/255.0f blue:255/255.0f alpha:1];
        [_rootTableView registerClass:[XLsn0wCityTableViewCell class] forCellReuseIdentifier:@"cityCell"];
        [_rootTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cityNameCell"];
    }
    return _rootTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _characterMutableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section < _HeaderSectionTotal ? 1 : [_sectionMutableArray[0][_characterMutableArray[section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < _HeaderSectionTotal) {
        self.cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
        if (_HeaderSectionTotal == 4 && indexPath.section == 0) {
            _cell.cityNameArray = _areaMutableArray;
        }
        if (indexPath.section == _HeaderSectionTotal - 3) {
            NSString *locationCity = [KCURRENTCITYINFODEFAULTS objectForKey:@"locationCity"];
            _cell.cityNameArray = locationCity ? @[locationCity] : @[@"正在定位..."];
        }
        if (indexPath.section == _HeaderSectionTotal - 2) {
            _cell.cityNameArray = self.historyCityMutableArray;
        }
        if (indexPath.section == _HeaderSectionTotal - 1) {
            _cell.cityNameArray = self.hotCityArray;
        }
    return _cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityNameCell" forIndexPath:indexPath];
        NSArray *currentArray = _sectionMutableArray[0][_characterMutableArray[indexPath.section]];
        cell.textLabel.text = currentArray[indexPath.row];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_HeaderSectionTotal == 4 && indexPath.section == 0) {
        return _cellHeight;
    }else {
        return indexPath.section == (_HeaderSectionTotal - 1) ? 200 : 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_HeaderSectionTotal == 4 && section == 0) {
        return 0;
    }else{
        return 40;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_HeaderSectionTotal == 3) {
        switch (section) {
            case 0:
                return @"定位城市";
                break;
            case 1:
                return @"最近访问的城市";
                break;
            case 2:
                return @"热门城市";
                break;
            default:
                return _characterMutableArray[section];
                break;
        }
    }else {
        switch (section) {
            case 1:
                return @"定位城市";
                break;
            case 2:
                return @"最近访问的城市";
                break;
            case 3:
                return @"热门城市";
                break;
            default:
                return _characterMutableArray[section];
                break;
        }
    }
}

//设置右侧索引的标题，这里返回的是一个数组哦！
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _characterMutableArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _headerView.cityName = cell.textLabel.text;
    [KCURRENTCITYINFODEFAULTS setObject:cell.textLabel.text forKey:@"currentCity"];
    [_manager cityNumberWithCity:cell.textLabel.text cityNumber:^(NSString *cityNumber) {
        [KCURRENTCITYINFODEFAULTS setObject:cityNumber forKey:@"cityNumber"];
    }];
    if (self.choseCityBlock) {
        self.choseCityBlock(cell.textLabel.text);
    }
    [self historyCity:cell.textLabel.text];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --- JFLocationDelegate
- (void)locating {
    NSLog(@"定位中...");
}

//定位成功
- (void)currentLocation:(NSDictionary *)locationDictionary {
    NSString *city = [locationDictionary valueForKey:@"City"];
    [KCURRENTCITYINFODEFAULTS setObject:city forKey:@"locationCity"];
    [_manager cityNumberWithCity:city cityNumber:^(NSString *cityNumber) {
        [KCURRENTCITYINFODEFAULTS setObject:cityNumber forKey:@"cityNumber"];
    }];
    _headerView.cityName = city;
    [self historyCity:city];
    [_rootTableView reloadData];
}

/// 添加历史访问城市
- (void)historyCity:(NSString *)city {
    //避免重复添加，先删除再添加
    [_historyCityMutableArray removeObject:city];
    [_historyCityMutableArray insertObject:city atIndex:0];
    if (_historyCityMutableArray.count > 3) {
        [_historyCityMutableArray removeLastObject];
    }
    NSData *historyCityData = [NSKeyedArchiver archivedDataWithRootObject:self.historyCityMutableArray];
    [KCURRENTCITYINFODEFAULTS setObject:historyCityData forKey:@"historyCity"];
}

/// 拒绝定位
- (void)refuseToUsePositioningSystem:(NSString *)message {
    NSLog(@"%@",message);
}

/// 定位失败
- (void)locateFailure:(NSString *)message {
    NSLog(@"%@",message);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
