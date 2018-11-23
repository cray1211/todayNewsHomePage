//
//  ViewController.m
//  标签栏
//
//  Created by IOS on 17/2/21.
//  Copyright © 2017年 xushuo All rights reserved.
//  

#import "selectedTagViewController.h"
@interface selectedTagViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) ChannelView *channelView;
@property (nonatomic ,strong) UIPanGestureRecognizer *scrollViewPan;
@property (nonatomic ,strong) UIPanGestureRecognizer *channelViewPan;

@property (nonatomic ,strong) UILabel *nav;
@end

@implementation selectedTagViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *nav = [[UILabel alloc]init];
    nav.text = @"标签";
    nav.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
    nav.textAlignment = NSTextAlignmentCenter;
    nav.backgroundColor = [UIColor redColor];
    nav.font = [UIFont systemFontOfSize:20.0f];
    nav.textColor = [UIColor whiteColor];
    nav.hidden = YES;
    [self.view addSubview:nav];
    self.nav = nav;
    
    NSArray *upBtnDataArr = @[@"推荐",@"北京",@"社会",@"娱乐",@"问答",@"图片",@"财经"];
    NSArray *belowBtnDataArr = @[@"情感",@"家具",@"教育",@"三农",@"孕产",@"文化",@"游戏",@"股票",@"科学",@"动漫",@"故事",@"收藏",@"精选",@"语录",@"星座",@"美图",@"推荐",@"北京",@"社会",@"娱乐",@"问答",@"图片",@"财经",@"科技",@"汽车",@"体育",@"美女",@"健康",@"军事",@"国际",@"趣图",@"正能量",@"热点",@"手机",@"段子",@"房产",@"搞笑",@"历史",@"养生",@"科技",@"汽车",@"体育",@"美女",@"健康",@"军事",@"国际",@"趣图",@"正能量",@"热点",@"手机",@"段子",@"房产",@"搞笑",@"历史",@"养生"];
    
    
    
}

- (void)setUpTitleArr:(NSArray *)upTitleArr{
    _upTitleArr = upTitleArr;
//    [self setUpChannelView:_nav];
}
- (void) setDataForViewUpTitleArr:(NSArray *)upTitleArr allTitleArr:(NSArray *)allTitleArr{
    self.upTitleArr = upTitleArr;
    self.allTitleArr = allTitleArr;
    [self setUpChannelView:_nav];
}

- (void) setUpChannelView:(UILabel *)nav{
    self.channelView = [[ChannelView alloc]initWithFrame:CGRectMake(0, nav.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-nav.frame.size.height)];
    self.channelView.backgroundColor = [UIColor whiteColor];
    //添加数据
    self.channelView.upBtnDataArr = _upTitleArr;
    
    
    
    //copy出来一份  操作该数组  删除 没用的
    NSMutableArray *belowBtnDataArr = [NSMutableArray arrayWithArray:self.allTitleArr];
    //这种遍历方法   效率最高  但是使用CGD group开启子线程遍历  不能保证绝对的顺序
//    [self.allTitleArr enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//    }];
    
    //按照顺序 效率较高  对数组进行操作的时候 为防止数组越界crash  最好用逆遍历进行处理
//    [self.allTitleArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//    }];
    
    //方式3  逆遍历 并且操作元素
    for (NSString *title in self.allTitleArr.reverseObjectEnumerator) {
        for (NSString *upTitle in _upTitleArr) {
            if ([upTitle isEqualToString:title]) {
                //删除公共数组
                [belowBtnDataArr removeObject:upTitle];
            }
        }
    }
    
    
    
    self.channelView.belowBtnDataArr = belowBtnDataArr;
    //每行按钮个数
    self.channelView.btnNumber = 4;
    //默认不允许第一个按钮参与编辑
    self.channelView.IS_compileFirstBtn = NO;
    //设置按钮字体Font
    self.channelView.btnTextFont = 13.0f;
    //获取数据Block
    __weak typeof(self)weakSelf = self;
    //    self.channelView.dataBlock = ^(NSMutableArray *dataArr, option_Type optionType) {
    //        for (NSString *upBtnText in dataArr) {
    ////            NSLog(@"%@",upBtnText);
    //        }
    //        if (weakSelf.resultBlock) {
    //            weakSelf.resultBlock(dataArr, optionType);
    //        }
    //    };
    
    //操作完成回调
    self.channelView.moveUpBtnEndBlock = ^(NSMovePoint movePoint, NSMutableArray<NSString *> *dataArr, option_Type optionType) {
        if (weakSelf.resultBlock) {
            weakSelf.resultBlock(dataArr, optionType, movePoint);
        }
    };
    
    
    
    //点击的是哪个按钮的响应
    self.channelView.selectedUpBtn = ^(NSInteger index) {
        !weakSelf.selectItemCallBack ? : weakSelf.selectItemCallBack(index);
    };
    
    
    [self.view addSubview:self.channelView];
    
    
    //    //给view添加span收拾你
    UIPanGestureRecognizer *pan =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    //添加到指定视图
    pan.delegate = self;
    //    [self.channelView addGestureRecognizer:pan];
    self.channelViewPan = pan;
    
    //给view添加span手势
    UIPanGestureRecognizer *pan2 =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    //添加到指定视图
    pan2.delegate = self;
    [self.channelView.ScrollView addGestureRecognizer:pan2];
    self.scrollViewPan = pan2;
    
    //滚动【偏移量
    self.channelView.scrollViewBlock = ^(UIScrollView *scrollView) {
        //        NSLog(@" ----       %lf", scrollView.contentOffset.y);
        weakSelf.scrollViewPan.enabled = YES;
        
        if (scrollView.contentOffset.y > 0) {
            weakSelf.scrollViewPan.enabled = NO;
        }
    };
}



#pragma 平移手势
//创建平移手势
-(void)panAction:(UIPanGestureRecognizer *)pan
{
    NSLog(@"pan");
    //获取手势的位置
    CGPoint position =[pan translationInView:self.channelView];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        NSLog(@"开始");
    }
    if (position.y < 0) {
        //向上滑动
        NSLog(@"向上滑动");
        if (self.channelView.frame.origin.y == 0) {
            if ([pan.view isKindOfClass:[UIScrollView class]]) {
                self.scrollViewPan.enabled = NO;
            }
        }else{
            self.channelView.transform = CGAffineTransformTranslate(self.channelView.transform, 0, position.y);
        }
    }else{
        //通过stransform 进行平移交换
        NSLog(@"向下滑动");
        if ([pan.view isKindOfClass:[UIScrollView class]]) {
            self.channelView.transform = CGAffineTransformTranslate(self.channelView.transform, 0, position.y);
        }
    }
    //将增量置为零
    [pan setTranslation:CGPointZero inView:self.channelView];
    //结束判断是否恢复
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (self.channelView.frame.origin.y > 300) {
            //消失动画
            [self startAnnimation];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                self.channelView.frame = CGRectMake(0, 0, self.channelView.frame.size.width, self.channelView.frame.size.height);
            }];
        }
    }
    
}



-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //在这里判断是百度地图的view 既可以实现手势拖动 scrollview 的滚动关闭
    NSLog(@"手势-----%@", [gestureRecognizer.view class]);
    if (self.channelView.frame.origin.y == 0) {
//        return NO;
    }
    
    return YES;
}
    

    


- (void) startAnnimation{
    if (self.statAnimationBlock) {
        self.statAnimationBlock();
    }
}

@end
