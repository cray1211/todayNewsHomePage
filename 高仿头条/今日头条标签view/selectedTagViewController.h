//
//  ViewController.h
//  标签栏
//
//  Created by IOS on 17/2/21.
//  Copyright © 2017年 xushuoa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelView.h"
@interface selectedTagViewController : UIViewController

@property (nonatomic , copy) void(^statAnimationBlock)(void);
@property (nonatomic ,strong) void(^resultBlock)(NSArray *tigArr, option_Type optipnType, NSMovePoint movePoint);

@property (nonatomic ,strong) NSArray *allTitleArr;
@property (nonatomic, strong) NSArray *upTitleArr;

/**在非编辑状态下 点击第一分区 回调*/
@property (nonatomic ,strong) void(^selectItemCallBack)(NSInteger index);

- (void) setDataForViewUpTitleArr:(NSArray *)upTitleArr allTitleArr:(NSArray *)allTitleArr;

@end

