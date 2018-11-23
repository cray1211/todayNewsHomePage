//
//  ChannelView.h
//  标签栏
//
//  Created by admin on 2017/9/29.
//  Copyright © 2017年 xushuoa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum optionType
{
    OPTION_CHANGE = 0,//改变位置
    OPTION_ADD,//添加
    OPTION_DELETE,//删除一个
    OPTION_DEFAULT//默认操作
}option_Type;

//定义结构体
typedef struct _NSMovePoint {
    NSUInteger startIndex;
    NSUInteger destanceIndex;
} NSMovePoint;
////结构体初始化
NS_INLINE NSMovePoint NSMakeMovePoint(NSUInteger startIndex, NSUInteger destanceIndex) {
    NSMovePoint movePoint;
    movePoint.startIndex    = startIndex;
    movePoint.destanceIndex = destanceIndex;
    return movePoint;
}

@interface ChannelView : UIView

/**
 *上按钮数组
 **/
@property (nonatomic, strong) NSArray *upBtnDataArr;

/**
 *下按钮数组
 **/
@property (nonatomic, strong) NSArray *belowBtnDataArr;

/**
 *第一个按钮是否参与编辑 （默认为NO）
 **/
@property (nonatomic, assign) BOOL IS_compileFirstBtn;

/**
 *每行按钮个数 （默认为4）
 **/
@property (nonatomic, assign) int btnNumber;

/**
 *按钮字体大小
 **/
@property (nonatomic, assign) CGFloat btnTextFont;

/**
 *返回调整好的标签数组   赞弃用
 **/
@property (nonatomic, copy) void(^dataBlock)(NSMutableArray <NSString *>*dataArr, option_Type optionType);

/**
 在编辑完成状态下 获取点击上面view的btn的下标
 */
@property (nonatomic, copy) void(^selectedUpBtn)(NSInteger index);

/**
 每次移动完位置 回调 起始位置 与目标位置 配合collectionView
 */
@property (nonatomic, copy) void(^moveUpBtnEndBlock)(NSMovePoint movePoint, NSMutableArray <NSString *>*dataArr, option_Type optionType);



/**
 偏移量
 */
@property (nonatomic ,strong) void(^scrollViewBlock)(UIScrollView *scrollView);


/**
 公开scrollView
 */
@property (nonatomic, strong) UIScrollView *ScrollView;
@end
