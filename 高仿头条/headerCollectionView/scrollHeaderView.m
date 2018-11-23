//
//  scrollHeaderVIew.m
//  高仿头条
//
//  Created by sxf_pro on 2018/5/30.
//  Copyright © 2018年 sxf_pro. All rights reserved.
//

#import "scrollHeaderView.h"
#import "headerCollectionViewCell.h"

@interface scrollHeaderView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic ,strong) UIButton *addBtn;//➕按钮
@end


@implementation scrollHeaderView
- (void)setTitleDataSourceArr:(NSArray *)titleDataSourceArr{
    _titleDataSourceArr = titleDataSourceArr;
    //刷新collectionView
    [self.collectionView reloadData];
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(self.frame.size.width / 7, self.frame.size.height);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 20, self.frame.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 20);
    }
    return _collectionView;
}
- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 40, 0, 40, self.frame.size.height)];
        [_addBtn addTarget:self action:@selector(addItemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    _addBtn.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    [_addBtn setTitle:@"➕" forState:UIControlStateNormal];
    return _addBtn;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        [self addSubview:self.addBtn];
        [self.collectionView registerClass:[headerCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([headerCollectionViewCell class])];
    }
    
    //默认第一个选中
    self.selectedIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    
    return self;
}









- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titleDataSourceArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    headerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([headerCollectionViewCell class]) forIndexPath:indexPath];
    cell.titleLabel.text = self.titleDataSourceArr[indexPath.item];
    if (self.selectedIndexPath == indexPath) {
        cell.titleLabel.textColor = [UIColor redColor];
    }else{
        cell.titleLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    headerCollectionViewCell *item = (headerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//
//    item.titleLabel.textColor = [UIColor redColor];
    
    self.selectedIndexPath = indexPath;
    //滚动到屏幕中间
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    
    //block出去
    if (self.selectedItemBlock) {
        self.selectedItemBlock(collectionView, indexPath);
    }
}


//选择状态
- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    //取消选中
    headerCollectionViewCell *item = (headerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    item.titleLabel.textColor = [UIColor blackColor];
}



- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath{
    _selectedIndexPath = selectedIndexPath;
    [self.collectionView reloadData];
}

//添加按钮
- (void)addItemBtnClick:(UIButton *)sender{
    if (self.addBtnCallBackBlock) {
        self.addBtnCallBackBlock(sender);
    }
}




//collectionView可编辑状态
//移动动cell到另一cell
- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath{
    
}





@end
