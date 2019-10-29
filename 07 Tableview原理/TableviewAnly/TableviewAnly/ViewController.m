//
//  ViewController.m
//  TableviewAnly
//
//  Created by sy on 2018/3/30.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "ViewController.h"
#import "ThridViewCtr.h"
#import "SecondViewCtr.h"

/*

   
 3 实现
 
 
 4 总结分析
    优化，保存cell高度，就不需要每次都计算高度了（主要针对于可变cell的高度场景）
    1 数据处理（高度）
    2 UI，cell的处理如何更少占用主线程(一般使用SDWebImage会把图片缓存起来,结合上面的高度保存基本就不会卡顿了)
 
 5 实践
    tableview  sectionHeadView 悬浮效果
 
 6 问题
 1. reload刷新是异步的
 2. 预估高度estimatedRowHeight
 */

@interface ViewController (){
    
    IBOutlet UITableView *_tableview;
    
    NSMutableArray *_cellAry;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    
    _cellAry = [NSMutableArray new];
    
    _tableview.estimatedRowHeight = 0; // ios11
    
    
    [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_tableview reloadData];
    
//    for (int i = 0; i < 5; i++) {
//        sleep(1);
//        NSLog(@"=====");
//    }
    
}

#pragma mark - tableView delegate
// 646  一屏幕最多展示多少个cell：5
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld", (long)indexPath.row);
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   // NSLog(@"indexrow:%d", indexPath.row);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    BOOL isContain = NO;
    for(NSValue *value in _cellAry){
        
        //弱引用对象
        //详情可参考:https://www.jianshu.com/p/51156d4ae885
        if ([value.nonretainedObjectValue isEqual:cell]) {
            isContain = YES;
            break;
        }
    }
    if (!isContain) {
        NSValue *value = [NSValue valueWithNonretainedObject:cell];
        [_cellAry addObject:value];
    }
    
    cell.textLabel.text = [@(indexPath.row) description];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   // NSLog(@"%f", _tableview.contentSize.height);
    NSLog(@"==%lu", (unsigned long)_cellAry.count);
    
    [self.navigationController pushViewController:[ThridViewCtr new] animated:YES];
    //[self.navigationController pushViewController:[SecondViewCtr new] animated:YES];
    
}


@end
