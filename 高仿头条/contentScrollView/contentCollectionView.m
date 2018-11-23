//
//  contentCollectionView.m
//  高仿头条
//
//  Created by sxf_pro on 2018/5/30.
//  Copyright © 2018年 sxf_pro. All rights reserved.
//

#import "contentCollectionView.h"
#import "contentCollectionViewCell.h"

@interface contentCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource>

@end
@implementation contentCollectionView
- (void)setTitleDataSourceArr:(NSArray *)titleDataSourceArr{
    _titleDataSourceArr = titleDataSourceArr;
    //刷新collectionView
//    [self.collectionView reloadData];
}
//更新位置
- (void)changedWithTitleArr:(NSArray *)titleArr//标题数组
                 startIndex:(NSInteger)startIndex//起始位置
              destanceIndex:(NSInteger)destanceIndex//终点位置
                   optionType:(option_Type)optionType//操作模式
{
    self.titleDataSourceArr = titleArr;
    switch (optionType) {
        case OPTION_DEFAULT:
            NSLog(@"不做处理");
            break;
        case OPTION_ADD:
            NSLog(@"添加");
            //最后到添加
        {
            NSIndexSet *set = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(titleArr.count - 1, 1)];
            self.titleDataSourceArr = titleArr;
            [self.collectionView insertSections:set];
        }

            break;
        case OPTION_DELETE:
            NSLog(@"移除");
        {
            //移除指定位置的itemsection 在 startIndex中存储
            NSIndexSet *set = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(startIndex, 1)];
            [self.collectionView deleteSections:set];
            
        }
            break;
        case OPTION_CHANGE:
            NSLog(@"改变位置");
        {
            //交换item内容
            [self.collectionView moveSection:destanceIndex toSection:startIndex];
        }
            break;
        default:
            break;
    }
}


- (void)setScrollToIndex:(NSInteger)scrollToIndex{
    _scrollToIndex = scrollToIndex;
    
    //滚动到这一分区
    NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:scrollToIndex];
    [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}




- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
//        [self.collectionView registerClass:[contentCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([contentCollectionViewCell class])];
        //使用动态id
    }
    return self;
}








- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.titleDataSourceArr.count;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [NSString stringWithFormat:@"%@_%ld", NSStringFromClass([contentCollectionViewCell class]), (long)indexPath.section];
    [collectionView registerClass:[contentCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    contentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"item%ld\n\n%@",(long)indexPath.section, self.titleDataSourceArr[indexPath.section]];
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}
//可以移动
- (BOOL) collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"返回是否可移动");
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
#pragma mark - iOS9 之后的方法


- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
    NSLog(@"走到这里");
    
//    if (sourceIndexPath.section != destinationIndexPath.section) {
//        NSLog(@"不在同一分区");
//
//        //取出移动row数据
//        id color = self.dataArr[destinationIndexPath.row];
//
//        [self.dataArr removeObject:color];
//        //将数据插入到数据源中的目标位置
//        [self.dataArr insertObject:color atIndex:destinationIndexPath.row];
//
//
//        return;
//    }
//
//    //取出移动row数据
//    id color = self.dataArr[sourceIndexPath.row];
//    //从数据源中移除该数据
//    [self.dataArr removeObject:color];
//    //将数据插入到数据源中的目标位置
//    [self.dataArr insertObject:color atIndex:destinationIndexPath.row];
}






- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //滑动结束调用
    NSLog(@"DidEndDecelerating滚动到---%lf分区", scrollView.contentOffset.x  / self.collectionView.frame.size.width);
    NSInteger index = scrollView.contentOffset.x  / self.collectionView.frame.size.width;
    if (self.selectedItemBlock) {
        //配合分区头创建的path
        NSIndexPath *path = [NSIndexPath indexPathForItem:index inSection:0];
        self.selectedItemBlock(self.collectionView, path);
    }
}


//移动分区 到另一分区
- (void)moveSection:(NSInteger)section toSection:(NSInteger)newSection{
    
}
//插入一个分区
- (void)insertSections:(NSIndexSet *)sections{
    
}
@end
