//
//  ViewController.m
//  高仿头条
//
//  Created by sxf_pro on 2018/5/30.
//  Copyright © 2018年 sxf_pro. All rights reserved.
//

#import "playerVideoViewController.h"
#import "scrollHeaderView.h"
#import "contentCollectionView.h"
#import "sxf_tagViewController.h"
#import "selectedTagViewController.h"


//是否为iPhone X
#define kIs_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//获取屏幕宽度，高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface playerVideoViewController ()
{
    NSArray *_titleArr;
    NSArray *_allTitleArr;
}
@property (nonatomic ,strong) scrollHeaderView *headerView;
@property (nonatomic ,strong) contentCollectionView *contentView;
@property (nonatomic ,strong) UIView *windownBgView;
@property (nonatomic ,strong) selectedTagViewController *tagVC;


@end

@implementation playerVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scrollHeaderView *headerView = [[scrollHeaderView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化
    _titleArr = @[@"推荐",@"北京",@"社会",@"娱乐",@"问答",@"图片",@"财经"];
    _allTitleArr = @[@"情感",@"家具",@"教育",@"三农",@"孕产",@"文化",@"游戏",@"股票",@"科学",@"动漫",@"故事",@"收藏",@"精选",@"语录",@"星座",@"美图",@"推荐",@"北京",@"社会",@"娱乐",@"问答",@"图片",@"财经",@"科技",@"汽车",@"体育",@"美女",@"健康",@"军事",@"国际",@"趣图",@"正能量",@"热点",@"手机",@"段子",@"房产",@"搞笑",@"历史",@"养生",@"科技",@"汽车",@"体育",@"美女",@"健康",@"军事",@"国际",@"趣图",@"正能量",@"热点",@"手机",@"段子",@"房产",@"搞笑",@"历史",@"养生"];
    
    //取存储的值
    [self getData];
    
    
    
    //赋值
    headerView.titleDataSourceArr = _titleArr;
    
    
    
    self.headerView = headerView;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.headerView.bounds) + 64, self.view.frame.size.width, 1)];
    [self.view addSubview:lineView];
    lineView.backgroundColor = [UIColor grayColor];
    
    contentCollectionView *contentView = [[contentCollectionView alloc] initWithFrame:CGRectMake(0, 105, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - self.tabBarController.tabBar.frame.size.height - headerView.frame.size.height - self.navigationController.navigationBar.frame.size.height)];
    contentView.backgroundColor = [UIColor redColor];
    contentView.titleDataSourceArr = headerView.titleDataSourceArr;
    self.contentView = contentView;
    [self.view addSubview:contentView];

    //初始化选择状态回调
    [self initCallBackBlock];
}



- (void) initCallBackBlock{
    //头
    __weak typeof(self)weakSelf = self;
    self.headerView.selectedItemBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:indexPath.item];
            [weakSelf.contentView.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        });
    };
    //头部添加
    self.headerView.addBtnCallBackBlock = ^(UIButton *sender) {
        NSLog(@"添加le---------");
        //取存储的值
        [weakSelf getData];
        
        [weakSelf showTagView];
    };
    //内容
    self.contentView.selectedItemBlock = ^(UICollectionView *collectionView, NSIndexPath *indexPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //改变标题的位置
            [weakSelf.headerView.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            //改变标题的颜色
            weakSelf.headerView.selectedIndexPath = indexPath;
        });
    };
}

//弹出标签按钮呢
- (void) showTagView{
    __weak typeof(self)weakSelf = self;
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    self.tagVC = [[selectedTagViewController alloc] init];
    
    CGFloat top = kIs_iPhoneX ? 34 : 20;
    UIView *tagView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - top)];
    self.tagVC.view.frame = CGRectMake(0, 0, tagView.frame.size.width, tagView.frame.size.height);
    
    
    [_tagVC setDataForViewUpTitleArr:_titleArr allTitleArr:_allTitleArr];
    
    
    
    [tagView addSubview:self.tagVC.view];
    [keyWin addSubview:tagView];
    self.windownBgView = tagView;
    
    self.tagVC.selectItemCallBack = ^(NSInteger index) {
        NSLog(@"  %ld个按钮", (long)index);
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        //改变标题的位置
        [weakSelf.headerView.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        //滑动首页 到 该item 位置
        weakSelf.contentView.scrollToIndex = index;
        
        //改变标题的颜色
        weakSelf.headerView.selectedIndexPath = indexPath;
        
        //消失 tag页面
        [weakSelf closeTagView];
    };
    
    self.tagVC.resultBlock = ^(NSArray *tigArr, option_Type optionType, NSMovePoint movePoint) {
        
        //存数据 (序列化)
        NSData *upTitleData = [NSKeyedArchiver archivedDataWithRootObject:tigArr];
        [[NSUserDefaults standardUserDefaults] setValue:upTitleData forKey:topHeaderTitleArr];
        
        for (NSString *upBtnText in tigArr) {
            NSLog(@"%@",upBtnText);
        }
        NSLog(@"%lu    %lu", (unsigned long)movePoint.startIndex, (unsigned long)movePoint.destanceIndex);
        
        //刷新首页tag数据
        weakSelf.headerView.titleDataSourceArr = tigArr;
        
        //内容切换位置
//        weakSelf.contentView.titleDataSourceArr = tigArr;
        [weakSelf.contentView changedWithTitleArr:tigArr
                                       startIndex:movePoint.startIndex
                                    destanceIndex:movePoint.destanceIndex
                                       optionType:optionType];
        
        
        
        if (optionType == OPTION_ADD) {
            //header content 分必然滚动到 仅仅添加  滑动到最后
            //可在 content内部进行加载数据
            NSInteger scrollIndex = tigArr.count - 1;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:scrollIndex inSection:0];
            [weakSelf.headerView.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            //改变标题的颜色
            weakSelf.headerView.selectedIndexPath = indexPath;
            //滑动首页 到 该item 位置
            weakSelf.contentView.scrollToIndex = scrollIndex;
        }
        
        
    };
    
    [self.tagVC setStatAnimationBlock:^{
        [weakSelf closeTagView];
    }];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.windownBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.windownBgView.frame = CGRectMake(0, top, SCREEN_WIDTH, SCREEN_HEIGHT - top);
    } completion:^(BOOL finished) {
        self.windownBgView.frame = CGRectMake(0, top, SCREEN_WIDTH, SCREEN_HEIGHT - top);
    }];
    

    //停止拖拽执行动画
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeTagView) name:@"closeTaView" object:nil];
}

int num;
- (void) closeTagView{
    CGFloat top = kIs_iPhoneX ? 34 : 20;
    self.windownBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
    UIWindow *keyWin = [UIApplication sharedApplication].keyWindow;
    keyWin.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    
    
    
    NSLog(@"-------%d" , num ++);
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.windownBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
            self.windownBgView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - top);
            keyWin.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
        } completion:^(BOOL finished) {
            [self.windownBgView removeFromSuperview];
            
            self.windownBgView = nil;
//            self.windownBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        }];
    });
}


- (void) getData{
    //取 (序列化)
    NSData *allTitleData = [[NSUserDefaults standardUserDefaults] valueForKey:allHeaderTitleArr];
    NSArray *allTitleArr = [NSKeyedUnarchiver unarchiveObjectWithData:allTitleData];
    
    NSData *topTitleData = [[NSUserDefaults standardUserDefaults] valueForKey:topHeaderTitleArr];
    NSArray *topTitleArr = [NSKeyedUnarchiver unarchiveObjectWithData:topTitleData];
    
    if (allTitleArr) {
        _allTitleArr = allTitleArr;
    }
    if (topTitleArr) {
        _titleArr = topTitleArr;
    }
}


@end
