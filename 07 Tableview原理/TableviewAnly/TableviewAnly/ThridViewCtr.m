//
//  ThridViewCtr.m
//  TableviewAnly
//
//  Created by sy on 2018/3/30.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "ThridViewCtr.h"
#import "TaskTableView.h"

@interface ThridViewCtr ()<UITableViewDataSource, UITableViewDelegate>{
    
    IBOutlet TaskTableView *_tableview;
    IBOutlet UIView *_sectionOneHeadView;
    IBOutlet UIView *_sectionTwoHeadView;
}

@end

@implementation ThridViewCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    [_sectionOneHeadView removeFromSuperview];
    [_sectionTwoHeadView removeFromSuperview];
    
    _tableview.secionOneHeadView  = _sectionOneHeadView;
    _tableview.secionTwoHeadView  = _sectionTwoHeadView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 5;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return _sectionOneHeadView;
    }else{
        return _sectionTwoHeadView;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d--%d", indexPath.section, indexPath.row];
    return cell;
}



@end
