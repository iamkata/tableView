//
//  TaskTableView.m
//  TableviewAnly
//
//  Created by sy on 2018/3/30.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "TaskTableView.h"

@implementation TaskTableView

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // 重新布局headView位置
    
    CGFloat headViewWidth = self.secionOneHeadView.frame.size.width;
    CGFloat headViewHeight = self.secionOneHeadView.frame.size.height;
    //当前面五个cell已经滑过去的时候,重新布局
    if (self.contentOffset.y > 70 * 5 ) {
        
        self.secionOneHeadView.frame = CGRectMake(0, self.contentOffset.y, headViewWidth, headViewHeight);
        self.secionTwoHeadView.frame = CGRectMake(0, self.contentOffset.y + headViewHeight, headViewWidth, headViewHeight);
        
    }
    
    //系统默认会移除,所以我们重新添加上去
    if (![self.secionOneHeadView superview]) {
        [self addSubview:self.secionOneHeadView];
    }
}

@end
