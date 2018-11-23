//
//  myViewController.m
//  test
//
//  Created by 史小峰 on 2018/5/30.
//  Copyright © 2018年 SXF. All rights reserved.
//

#import "sxf_tagViewController.h"
#import "sxf_tagCollectionViewCell.h"
#import "sxf_tagCollectionReusableView.h"
@interface sxf_tagViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UICollectionView *collectionView;
/**之前选中cell的NSIndexPath*/
@property (nonatomic, strong) NSIndexPath *oldIndexPath;
/**单元格的截图*/
@property (nonatomic, strong) UIView *snapshotView;
/**之前选中cell的NSIndexPath*/
@property (nonatomic, strong) NSIndexPath *moveIndexPath;

/**起始point*/
@property (nonatomic ,assign) CGPoint startPoint;
@end

@implementation sxf_tagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.dataArr = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < 50; index ++) {
        CGFloat hue = (arc4random()%256/256.0); //0.0 到 1.0
        CGFloat saturation = (arc4random()%128/256.0)+0.5; //0.5 到 1.0
        CGFloat brightness = (arc4random()%128/256.0)+0.5; //0.5 到 1.0
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:0.5];
        [self.dataArr addObject:color];
    }

    CGFloat SCREEN_WIDTH = self.view.frame.size.width;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH-50.0)/4, 40);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - 20) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([sxf_tagCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([sxf_tagCollectionViewCell class])];
    [collectionView registerClass:[sxf_tagCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:self.collectionView = collectionView];
    
    // 添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    [collectionView addGestureRecognizer:longPress];
    
    self.collectionView = collectionView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    sxf_tagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([sxf_tagCollectionViewCell class]) forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld--%ld", indexPath.section, indexPath.row];
    cell.backgroundColor = self.dataArr[indexPath.row];
    return cell;
}




- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        sxf_tagCollectionReusableView *resableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        resableView.titleLabel.text = [NSString stringWithFormat:@"第%ld分区", indexPath.section];
        resableView.editeBtn.tag = indexPath.section;
        if(indexPath.section == 0){
            resableView.editeBtn.hidden = NO;
            resableView.editeBtnBlock = ^(UIButton *sender) {
                [self dismissViewControllerAnimated:YES completion:nil];
            };
        }else{
            resableView.editeBtn.hidden = YES;
        }
        return resableView;
    }else{
        return nil;
    }
    return nil;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.frame.size.width, 50);
}


//可以移动
- (BOOL) collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    //在这里判断分区1是否可移动
    if (self.oldIndexPath.section == indexPath.section) {
        return YES;
    }
    return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}



- (void) handlelongGesture:(UILongPressGestureRecognizer *)longPress{
    
    [self iOS9_Action:longPress];
}


#pragma mark - iOS9 之后的方法


- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
    NSLog(@"走到这里");
    
    if (sourceIndexPath.section != destinationIndexPath.section) {
        NSLog(@"不在同一分区");
        
        //取出移动row数据
        id color = self.dataArr[destinationIndexPath.row];
        
        [self.dataArr removeObject:color];
        //将数据插入到数据源中的目标位置
        [self.dataArr insertObject:color atIndex:destinationIndexPath.row];
        
        
        return;
    }
    
    //取出移动row数据
    id color = self.dataArr[sourceIndexPath.row];
    //从数据源中移除该数据
    [self.dataArr removeObject:color];
    //将数据插入到数据源中的目标位置
    [self.dataArr insertObject:color atIndex:destinationIndexPath.row];
}

- (void)iOS9_Action:(UILongPressGestureRecognizer *)longPress
{
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
        { //手势开始
            //判断手势落点位置是否在row上
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
            self.oldIndexPath = indexPath;
            
             
            
            NSLog(@"开始-所在分区-----%ld", (long)indexPath.section);
            NSLog(@"我在这里");
            if (indexPath == nil) {
                break;
            }
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
            [self.view bringSubviewToFront:cell];
            //iOS9方法 移动cell
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:
        { // 手势改变
            NSLog(@"手势移动");
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
            self.moveIndexPath = indexPath;
            NSLog(@"移动-所在分区-----%ld", (long)indexPath.section);
            
            
            // iOS9方法 移动过程中随时更新cell位置
//            if (self.oldIndexPath.section != self.moveIndexPath.section) {
//                NSLog(@"不在同一分区 不让移动");
//            }else{
                [self.collectionView updateInteractiveMovementTargetPosition:[longPress locationInView:self.collectionView]];
//            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        { // 手势结束
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
            self.moveIndexPath = indexPath;
            NSLog(@"结束-所在分区-----%ld", (long)indexPath.section);
            
            
            if (self.oldIndexPath.section != self.moveIndexPath.section) {
                NSLog(@"不在同一分区 不让移动");
                //移动到起始点
                [self.collectionView updateInteractiveMovementTargetPosition:self.startPoint];   
            }else{
                
            }
            
            
            
            // iOS9方法 移动结束后关闭cell移动
            [self.collectionView endInteractiveMovement];
        }
            break;
        default: //手势其他状态
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}



@end
