//
//  SecondViewCtr.m
//  TableviewAnly
//
//  Created by sy on 2018/3/30.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "SecondViewCtr.h"
#import "EOCTableView.h"

@interface SecondViewCtr ()<EOCTableViewDelegate>{

    EOCTableView *_tableView;
}

@end

@implementation SecondViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[EOCTableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    [_tableView reloadData];
    [self.view addSubview:_tableView];
    
}

- (NSInteger)tableView:(EOCTableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 200;
}

// 性能优化1: 假如高度都不一样 【tableView reload】去计算 重新计算200cell的高度,计算量会很大,所以常见的优化手段就是保存高度
- (CGFloat)tableView:(EOCTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return  60;
}

- (UITableViewCell *)tableView:(EOCTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 //   性能优化1:UI，cell的处理如何更少占用主线程
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
     cell.textLabel.text = [@(indexPath.row) description];
    return cell;
    
}

@end
