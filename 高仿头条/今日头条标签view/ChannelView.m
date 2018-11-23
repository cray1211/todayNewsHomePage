//
//  ChannelView.m
//  标签栏
//
//  Created by admin on 2017/9/29.
//  Copyright © 2017年 xushuo. All rights reserved.
//

#import "ChannelView.h"

@interface ChannelView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) NSMutableArray *upBtn;
@property (nonatomic, strong) NSMutableArray *belowBtn;

@property (nonatomic, strong) NSMutableArray <NSValue*>*upFranmeArr;
@property (nonatomic, strong) NSMutableArray <NSValue*>*belowFranmeArr;

@property (nonatomic, weak) UILabel *channelLabel;
@property (nonatomic, weak) UIButton *compileBtn;



@property (nonatomic ,assign) NSInteger startIndex;//开始位置
@property (nonatomic ,assign) NSInteger destenceIndex;//目标位置
@property (nonatomic ,assign) NSMovePoint movePoint;//代替上面的起始位置


@property (nonatomic ,assign) option_Type optionType;//操作模式

@end

@implementation ChannelView

-(NSMutableArray *)upBtn{
    if (!_upBtn) {
        _upBtn = [NSMutableArray array];
    }
    return _upBtn;
}

-(NSMutableArray *)belowBtn{
    if (!_belowBtn) {
        _belowBtn = [NSMutableArray array];
    }
    return _belowBtn;
}


-(NSMutableArray *)upFranmeArr{
    if (!_upFranmeArr) {
        _upFranmeArr = [NSMutableArray array];
    }
    return _upFranmeArr;
}

-(NSMutableArray *)belowFranmeArr{
    if (!_belowFranmeArr) {
        _belowFranmeArr = [NSMutableArray array];
    }
    return _belowFranmeArr;
}

static CGFloat btnW;
static CGFloat btnH;


//当自己重写一个UIView的时候有可能用到这个方法,当本视图的父类视图改变的时候,系统会自动的执行这个方法.newSuperview是本视图的新父类视图.newSuperview有可能是nil.
- (void)willMoveToSuperview:(UIView *)newSuperview;
{
    if (self.btnNumber == 0) {
        self.btnNumber = 4;
    }
    
    btnW = (self.frame.size.width-20-(self.btnNumber-1)*10)/self.btnNumber;
    btnH = btnW/2;
    
    self.ScrollView = [[UIScrollView alloc]init];
    self.ScrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.ScrollView.backgroundColor = [UIColor colorWithRed:244/255.0f green:245/255.0f blue:246/255.0f alpha:1.0f];
    [self addSubview:self.ScrollView];
    self.ScrollView.delegate = self;
    
    UILabel *compileLabel = [[UILabel alloc]init];
    compileLabel.text = @"我的频道";
    compileLabel.font = [UIFont systemFontOfSize:15.0f];
    compileLabel.frame = CGRectMake(10, 0, 100, 50);
    [self.ScrollView addSubview:compileLabel];
    
    self.backgroundView = [[UIView alloc]init];
    self.backgroundView.frame = CGRectMake(10, compileLabel.frame.size.height, self.frame.size.width-20, ((self.upBtnDataArr.count+self.belowBtnDataArr.count)/self.btnNumber)*btnH+10*((self.upBtnDataArr.count+self.belowBtnDataArr.count)/self.btnNumber)+100 + btnH);
    [self.ScrollView addSubview:self.backgroundView];
    
    self.ScrollView.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(self.backgroundView.frame)+btnH);
    
    
    UIButton *compileBtn = [[UIButton alloc]init];
    [compileBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [compileBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [compileBtn addTarget:self action:@selector(compileBtn:) forControlEvents:UIControlEventTouchUpInside];
    [compileBtn setTitle:@"完成" forState:UIControlStateSelected];
    compileBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    compileBtn.frame = CGRectMake(self.ScrollView.frame.size.width-60, 0, 50, 50);
    [self.ScrollView addSubview:compileBtn];
    self.compileBtn = compileBtn;
    
    for (int i = 0; i < self.upBtnDataArr.count; i ++) {
        int a = (i/self.btnNumber);
        UIButton *btn  = [self addBtnFrame:CGRectMake((i%self.btnNumber)*btnW+(i%self.btnNumber)*10, a*btnH + a*10, btnW, btnH)];
        [btn addTarget:self action:@selector(clickUpBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:self.upBtnDataArr[i] forState:UIControlStateNormal];
        
        //初始化时候 给按钮添加tag值
        btn.tag = i;
        
        //添加手势
        [self addLongPress:btn];
        [self.upFranmeArr addObject:[NSValue valueWithCGRect:btn.frame]];
        [self.upBtn addObject:btn];
        
        
   
    }
    
    UILabel *channelLabel = [[UILabel alloc]init];
    channelLabel.text = @"频道推荐";
    channelLabel.font = compileLabel.font;
    if (self.upFranmeArr.count == 0) {
        channelLabel.frame = CGRectMake(0, 0, self.backgroundView.frame.size.width, 100-btnH);
    }else{
        channelLabel.frame = CGRectMake(0, CGRectGetMaxY(self.upFranmeArr[self.upFranmeArr.count-1].CGRectValue), self.backgroundView.frame.size.width, 100-btnH);
    }
    
    
    [self.backgroundView addSubview:channelLabel];
    self.channelLabel = channelLabel;
    
    for (int j = 0; j < self.belowBtnDataArr.count; j ++) {
        int b = (j/self.btnNumber);
        UIButton *btn;
        
        if (self.upFranmeArr.count == 0) {
            btn = [self addBtnFrame:CGRectMake((j%self.btnNumber)*btnW+(j%self.btnNumber)*10, b*btnH + b*10 +  compileLabel.frame.size.height, btnW, btnH)];
        }else{
            btn = [self addBtnFrame:CGRectMake((j%self.btnNumber)*btnW+(j%self.btnNumber)*10, b*btnH + b*10 +  [self.upFranmeArr[self.upFranmeArr.count-1] CGRectValue].origin.y+compileLabel.frame.size.height*2, btnW, btnH)];
        }
        
        [btn addTarget:self action:@selector(clickBelowBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[NSString stringWithFormat:@"+%@", self.belowBtnDataArr[j]] forState:UIControlStateNormal];
        [self.belowFranmeArr addObject:[NSValue valueWithCGRect:btn.frame]];
        [self.belowBtn addObject:btn];
    }
    
    UIImageView *jianbian = [[UIImageView alloc]init];
    jianbian.image = [UIImage imageNamed:@"渐变"];
    jianbian.frame = CGRectMake(0, self.frame.size.height-50, self.frame.size.width, 50);
    [self addSubview:jianbian];
}


-(UIButton *)addBtnFrame:(CGRect)frame{
    UIButton *btn  = [[UIButton alloc]init];
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor colorWithRed:215/255.0f green:215/255.0f blue:215/255.0f alpha:1.0].CGColor;
    btn.backgroundColor = [UIColor whiteColor];
    btn.frame = frame;
    btn.titleLabel.font = [UIFont systemFontOfSize:self.btnTextFont];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.backgroundView addSubview:btn];
    
    UIImageView *militaryFork = [[UIImageView alloc]init];
    CGFloat militaryForkWH = btn.frame.size.width*0.25;
    militaryFork.layer.masksToBounds = YES;
    militaryFork.layer.cornerRadius = militaryForkWH/2;
    militaryFork.frame = CGRectMake(btn.frame.size.width-militaryForkWH+2, -2, militaryForkWH, militaryForkWH);
    militaryFork.image = [UIImage imageNamed:@"叉号2"];
    militaryFork.hidden = YES;
    [btn addSubview:militaryFork];
    
    return btn;
}

- (void) handleLongPressGestures:(UILongPressGestureRecognizer *)paramSender{
    if (!self.compileBtn.selected) {
        return;
    }
    UIView *view = paramSender.view;
    
    
#pragma sxf add----记录起始位置
    self.startIndex = view.tag;
    static  CGRect viewFrame;
    if (paramSender.state == UIGestureRecognizerStateBegan){
        [self.backgroundView insertSubview:view atIndex:self.backgroundView.subviews.count-1];
        viewFrame = view.frame;
        CGAffineTransform transform = CGAffineTransformScale(view.transform, 1.2f, 1.2f);
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.0f];
        [view setTransform:transform];
        [UIView commitAnimations];
    }
    
    if (paramSender.state == UIGestureRecognizerStateChanged) {
        CGPoint location = [paramSender locationInView:paramSender.view.superview];
        view.center = location;
        for (int i = 0; i < self.upBtn.count; i ++) {
            if (i == 0 && !self.IS_compileFirstBtn) continue;
            UIButton *btn = self.upBtn[i];
            if (btn == view)continue;
            if (CGRectContainsPoint(btn.frame,location)) {
                [self.upBtn removeObject:view];
                [self.upBtn insertObject:view atIndex:i];
                #pragma sxf add-------记录到达哪个地方
                self.destenceIndex = i;
                [UIView animateWithDuration:0.3 animations:^{
                    [self.upBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj != view) {
                            obj.frame = [self.upFranmeArr[idx] CGRectValue];
                        }else{
                            viewFrame = [self.upFranmeArr[idx] CGRectValue];
                        }
                        
                    }];
                }];
                
                break;
            }
        }
    }
    
    if (paramSender.state == UIGestureRecognizerStateEnded) {
        view.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.3 animations:^{
            view.frame = viewFrame;
        }];
        
        
        
#pragma mark ---- sxfadd
        //每次移动结束回调位置刷新首页位置
//        NSLog(@"从%ld移动到%ld", self.startIndex, self.destenceIndex);
//        !self.moveUpBtnEndBlock ? : self.moveUpBtnEndBlock(self.startIndex, self.destenceIndex);
        
        //结束需要重新添加tag
//        [self.upBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            //可在这里添加tag 记录点击的是哪个
//            obj.tag = idx;
//        }];
        self.optionType = OPTION_CHANGE;
        [self getResult];
#pragma mark ---- sxfadd
        
    }
}

#pragma mark sxfAdd---伪编辑完成状态 每次改变回调数据
- (void) getResult{
    //完成状态下
    NSMutableArray *upBtnText = [NSMutableArray array];
    [self.upBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //可在这里添加tag 记录点击的是哪个
        obj.tag = idx;
        for (UIImageView *militaryFork in obj.subviews) {
            if ([militaryFork isKindOfClass:[UIImageView class]]) {
                militaryFork.hidden = !self.compileBtn.selected;
                if (idx == 0 && !self.IS_compileFirstBtn){
                    militaryFork.hidden = YES;
                }
            }
        }
        [upBtnText addObject:obj.titleLabel.text];
    }];
    if (self.dataBlock) {
        self.dataBlock(upBtnText, self.optionType);
    }
    //移动位置回调
    NSMovePoint point = NSMakeMovePoint(self.startIndex, self.destenceIndex);
    self.movePoint = point;
    !self.moveUpBtnEndBlock ? : self.moveUpBtnEndBlock(self.movePoint, upBtnText, self.optionType);
}

//编辑
-(void)compileBtn:(UIButton *)btn{
    if (btn.selected) {
        //完成状态下
        NSMutableArray *upBtnText = [NSMutableArray array];
        [self.upBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //可在这里添加tag 记录点击的是哪个
            obj.tag = idx;
            
            for (UIImageView *militaryFork in obj.subviews) {
                if ([militaryFork isKindOfClass:[UIImageView class]]) {
                    militaryFork.hidden = YES;
                }
            }
            [upBtnText addObject:obj.titleLabel.text];
        }];
        self.optionType = OPTION_DEFAULT;
        if (self.dataBlock) {//弃用这个block
            self.dataBlock(upBtnText, self.optionType);
        }
        //回调
         btn.selected = !btn.selected;
        [self getResult];
    }else{
        //编辑状态下
        [self.upBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            for (UIImageView *militaryFork in obj.subviews) {
                if ([militaryFork isKindOfClass:[UIImageView class]]) {
                    militaryFork.hidden = NO;
                    if ([obj.titleLabel.text isEqualToString:self.upBtnDataArr[0]] && !self.IS_compileFirstBtn) {
                        militaryFork.hidden = YES;
                    }
                }
            }
            
        }];
        btn.selected = !btn.selected;
    }
}

//点击上btn  移除 并记录移除的index
-(void)clickUpBtn:(UIButton *)btn{
    
    if (!self.compileBtn.selected) {
        //回调点击的是哪个按钮呢
        if (self.selectedUpBtn) {
            self.selectedUpBtn(btn.tag);
        }
        
        return;
    }
    if ([btn.titleLabel.text isEqualToString:self.upBtnDataArr[0]] && !self.IS_compileFirstBtn) {
        return;
    }
    for (UIImageView *militaryFork in btn.subviews) {
        if ([militaryFork isKindOfClass:[UIImageView class]]) {
            militaryFork.hidden = YES;
        }
    }
 
    [btn removeTarget:self action:@selector(clickUpBtn:) forControlEvents:UIControlEventTouchUpInside];

    [btn removeGestureRecognizer:btn.gestureRecognizers[0]];
    
    [btn addTarget:self action:@selector(clickBelowBtn:) forControlEvents:UIControlEventTouchUpInside];

    [self.upBtn removeObject:btn];
    //这里移除frame太早了  放在最后移除  下面布局frame 要用
//    [self.upFranmeArr removeObjectAtIndex:self.upFranmeArr.count-1];
    
    //删除掉一个按钮之后 给这个按钮 添加+号
    [btn setTitle:[NSString stringWithFormat:@"+%@", btn.titleLabel.text] forState:UIControlStateNormal];
    [self.belowBtn insertObject:btn atIndex:0];
    
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.upBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = self.upFranmeArr[idx].CGRectValue;
        }];
    }];
    
    [self.belowFranmeArr removeAllObjects];
    [UIView animateWithDuration:0.3 animations:^{
        [self.belowBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger j, BOOL * _Nonnull stop) {
            int b = ((int)j/self.btnNumber);
            obj.frame = CGRectMake((j%self.btnNumber)*btnW+(j%self.btnNumber)*10, b*btnH + b*10 +  [self.upFranmeArr[self.upFranmeArr.count-1]CGRectValue].origin.y+100, btnW, btnH);
            [self.belowFranmeArr addObject:[NSValue valueWithCGRect:obj.frame]];
        }];
    }];

    [UIView animateWithDuration:0.3 animations:^{
        
        //这里添加判断 当最后一个可点击 并且删除了最后一个的时候 那么就要在这里  布局以下 根据您需求 要不要 上移 下面的fram
        
        self.channelLabel.frame = CGRectMake(0, CGRectGetMaxY(self.upFranmeArr[self.upFranmeArr.count-1].CGRectValue), self.channelLabel.frame.size.width, self.channelLabel.frame.size.height);
    }];
    
    
    [self.upFranmeArr removeObjectAtIndex:self.upFranmeArr.count-1];
    
#pragma mark sxfAdd-----------
    //更新
    self.optionType = OPTION_DELETE;
    self.startIndex = btn.tag;//记录移除的下标
    [self getResult];
}


//添加长按手势
-(void)addLongPress:(UIButton *)btn{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleLongPressGestures:)];
    longPress.numberOfTouchesRequired = 1;
    longPress.allowableMovement = 100.0f;
    longPress.minimumPressDuration = 1.0;
    [btn addGestureRecognizer:longPress];
}

//点击下Btn
-(void)clickBelowBtn:(UIButton *)btn{
    if (self.compileBtn.selected) {
        for (UIImageView *militaryFork in btn.subviews) {
            if ([militaryFork isKindOfClass:[UIImageView class]]) {
                militaryFork.hidden = NO;
            }
        }
    }
    [btn removeTarget:self action:@selector(clickBelowBtn:) forControlEvents:UIControlEventTouchUpInside];
   
    [btn addTarget:self action:@selector(clickUpBtn:) forControlEvents:UIControlEventTouchUpInside];
  
    [self addLongPress:btn];
    
    [self.belowFranmeArr removeObjectAtIndex:self.belowFranmeArr.count-1];
    [self.belowBtn removeObject:btn];
    
    
    
    //添加之前把这个按钮的➕号删除
    [btn setTitle:[btn.titleLabel.text substringFromIndex:1] forState:UIControlStateNormal];
    
    [self.upBtn addObject:btn];
    int i = (int)self.upBtn.count-1;
    int a = ((int)i/self.btnNumber);
    
    //重新设置fram 给按钮添加tag
    [UIView animateWithDuration:0.3 animations:^{
        btn.frame =  CGRectMake((i%self.btnNumber)*btnW+(i%self.btnNumber)*10, a*btnH + a*10, btnW, btnH);
        [self.upFranmeArr addObject:[NSValue valueWithCGRect:btn.frame]];
        self.channelLabel.frame = CGRectMake(0, CGRectGetMaxY(self.upFranmeArr[self.upFranmeArr.count-1].CGRectValue), self.channelLabel.frame.size.width, self.channelLabel.frame.size.height);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.belowBtn enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            int b = ((int)idx/self.btnNumber);
            CGRect btnFrame = self.belowFranmeArr[idx].CGRectValue;
            obj.frame = CGRectMake(btnFrame.origin.x,  b*btnH + b*10 +  [self.upFranmeArr[self.upFranmeArr.count-1]CGRectValue].origin.y+100, btnFrame.size.width, btnFrame.size.height);
        }];
    }];
    
    
    
#pragma mark sxfAdd-----------
    //更新
    self.optionType = OPTION_ADD;
    [self getResult];
}

#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y <= 0) {
        scrollView.panGestureRecognizer.enabled = NO;
    }
    
    if (self.scrollViewBlock) {
        self.scrollViewBlock(scrollView);
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"停止Decelerat");
    scrollView.panGestureRecognizer.enabled = YES;
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    scrollView.panGestureRecognizer.enabled = YES;
    NSLog(@"停止drag");
    if (self.scrollViewBlock) {
        self.scrollViewBlock(scrollView);
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"停止动画");
    scrollView.panGestureRecognizer.enabled = YES;
}

@end
