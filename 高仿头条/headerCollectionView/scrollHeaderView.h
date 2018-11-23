//
//  scrollHeaderVIew.h
//  高仿头条
//
//  Created by sxf_pro on 2018/5/30.
//  Copyright © 2018年 sxf_pro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface scrollHeaderView : UIView
@property (nonatomic ,strong) NSArray <NSString *>*titleDataSourceArr;
@property (nonatomic ,strong) UICollectionView *collectionView;
//修改标题颜色
@property (nonatomic ,strong) NSIndexPath *selectedIndexPath;
//选中
@property (nonatomic ,strong) void(^selectedItemBlock)(UICollectionView *collectionView , NSIndexPath *indexPath);

/*添加按钮回调*/
@property (nonatomic ,strong) void(^addBtnCallBackBlock)(UIButton *sender);
@end
