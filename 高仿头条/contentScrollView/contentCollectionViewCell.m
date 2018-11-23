
//
//  contentCollectionViewCell.m
//  高仿头条
//
//  Created by sxf_pro on 2018/5/30.
//  Copyright © 2018年 sxf_pro. All rights reserved.
//

#import "contentCollectionViewCell.h"
#import "contentTableViewCell.h"
@interface contentCollectionViewCell()<UITableViewDelegate, UITableViewDataSource>

@end


@implementation contentCollectionViewCell

- (void)setDataModelArr:(NSArray *)dataModelArr{
    _dataModelArr = dataModelArr;
    [self.tableView reloadData];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        
        
    }
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        [self addChidrenViews];
    
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        titleLabel.center = self.contentView.center;
        
        titleLabel.text = self.reuseIdentifier;
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:titleLabel];
        
        titleLabel.backgroundColor = [UIColor orangeColor];
        
        self.titleLabel = titleLabel;
        
    }
    return self;
}

- (void) addChidrenViews{
    //添加
    [self.contentView addSubview:self.tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.dataModelArr = @[@"" , @"" , @"",@"" , @"" , @"",@"" , @"" , @"",@"" , @"" , @""];
    
    [_tableView registerClass:[contentTableViewCell class] forCellReuseIdentifier:NSStringFromClass([contentTableViewCell class])];
    _tableView.estimatedRowHeight = 200;//开启自动行高
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.tableView.frame = self.contentView.frame;
}






#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataModelArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    contentTableViewCell *cell = [contentTableViewCell cellForTableView:tableView atIndexPath:indexPath];

    
    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.estimatedRowHeight;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return tableView.estimatedRowHeight;
//}


@end
