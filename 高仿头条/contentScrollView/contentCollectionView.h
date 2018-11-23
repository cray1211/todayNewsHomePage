//
//  contentCollectionView.h
//  高仿头条
//
//  Created by sxf_pro on 2018/5/30.
//  Copyright © 2018年 sxf_pro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelView.h"
@interface contentCollectionView : UIView
@property (nonatomic ,strong) NSArray <NSString *>*titleDataSourceArr;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) void(^selectedItemBlock)(UICollectionView *collectionView , NSIndexPath *indexPath);


//点选后 自动滑动到 该位置
@property (nonatomic ,assign) NSInteger scrollToIndex;

//更新位置
- (void)changedWithTitleArr:(NSArray *)titleArr//标题数组
                 startIndex:(NSInteger)startIndex//起始位置
              destanceIndex:(NSInteger)destanceIndex//终点位置
                   optionType:(option_Type)optionType;//操作模式



@end
