//
//  EOCTableView.m
//  TableviewAnly
//
//  Created by sy on 2018/3/30.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "EOCTableView.h"
#import "EOCCellModel.h"


@interface EOCTableView(){
    
    NSMutableDictionary *_visibleCellDict; // 现有池
    
    NSMutableArray *_reusePoolCellAry; // 重用池
    
    NSMutableArray *_cellInfoArr; // cell 信息 (y值,高度,数量信息)
}

@end

// 667  cell高度 60，    660/60 = 11，7个像素可以显示2个残的  界面最多可以显示 11 + 2 = 13

@implementation EOCTableView

/*
 1现有池
 2重用池
 3位置信息
 */

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        _visibleCellDict = [NSMutableDictionary new];
        _reusePoolCellAry = [NSMutableArray new];
        _cellInfoArr = [NSMutableArray new];
    }
    return self;
}

#pragma mark - 数据,UI
/*
 数据， UI
 */
- (void)reloadData{
    
    // 1 处理数据
    [self dataHandle];
    // 2 UI 处理
    [self setNeedsLayout];
    
}

// 1. 处理数据， 数据model不会复用,只是保存下来
- (void)dataHandle{
    
    // 1.1 获取cell的数量
    NSInteger allCellCount = [self.delegate tableView:self numberOfRowsInSection:0];
    
    [_cellInfoArr removeAllObjects]; // 移除旧的信息
    
    CGFloat totalCellHeight = 0;
    for (int i = 0; i < allCellCount; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        CGFloat cellHeight = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
        //1.2 获取cell的高度和y值, 并保存起来
        EOCCellModel *model = [EOCCellModel new];
        model.y = totalCellHeight;
        model.height = cellHeight;
        
        [_cellInfoArr addObject:model];
        
        totalCellHeight += cellHeight;
    }
    
    //根据总高度设置可以滑动的范围
    [self setContentSize:CGSizeMake(self.frame.size.width, totalCellHeight)];
}

// 2. UI处理， UI会复用
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // 2.1 计算可视范围，要显示哪些cell，并把相关cell显示到界面
    CGFloat startY = self.contentOffset.y;
    CGFloat endY = self.contentOffset.y + self.frame.size.height;
    if (startY < 0) {
        startY = 0;
    }
    if (endY > self.contentSize.height) {
        endY = self.contentSize.height;
    }
    
    // 2.2 计算边界的cell索引 （从哪几个到哪几个cell， 如第3个到第9个）
    
    EOCCellModel *startModel = [EOCCellModel new];
    startModel.y = startY;
    
    EOCCellModel *endModel = [EOCCellModel new];
    endModel.y = endY;
    
    // 2.3 目地就是获取可视区域显示cell的索引范围
    //使用二分查找,替换下面的方法,效率更高
    //查找：用二分查找（1024 = 2的10次方 查找次数最多10次）
    NSInteger startIndex = [self binarySerchOC:_cellInfoArr target:startModel];
    NSInteger endIndex = [self binarySerchOC:_cellInfoArr target:endModel];
    
//    // 2.3.1 开始索引
//    for(NSInteger i = 0; i < _cellInfoArr.count; i++){
//
//        EOCCellModel *cellModel = _cellInfoArr[i];
//
//        if (cellModel.y <= startY && cellModel.y + cellModel.height > startY) {
//            startIndex = i;
//            break;
//        }
//    }
//    // 2.3.2 结束索引
//    for (NSInteger i = startIndex + 1; i < _cellInfoArr.count; i++) {
//
//        EOCCellModel *cellModel = _cellInfoArr[i];
//        if (cellModel.y < endY && cellModel.y + cellModel.height >= endY) {
//            endIndex = i;
//            break;
//        }
//    }
    
    // 2.4 UI操作 获取cell，并显示到View上
    for (NSInteger i = startIndex; i <= endIndex; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        //这个代理方法里面执行了重用机制方法dequeueReusableCellWithIdentifier
        UITableViewCell *cell = [self.delegate tableView:self cellForRowAtIndexPath:indexPath];
        // 当row = 3 的时候, 如果现有池有个相同的CellA,就返回cellA
        // 当row = 4 的时候，现有池不存相关的cell，然后去重用池读取cell，发现重用池有一个cellA，于是就返回了cellA
        
        EOCCellModel *cellModel = _cellInfoArr[i];
        cell.frame = CGRectMake(0, cellModel.y, self.frame.size.width, cellModel.height);
        
        if (![cell superview]) {
            [self addSubview:cell]; // 添加到tableview上  // addsubivew
        }
    }
    
    // 2.5 从现有池里面移走不在界面上的cell，移动到重用池里(把不在可视区域的cell移到重用池)
    NSArray *visibelCellKey = _visibleCellDict.allKeys;
    for (NSInteger i = 0; i < visibelCellKey.count; i++) {
        
        NSInteger index = [visibelCellKey[i] integerValue];
        if (index < startIndex || index > endIndex) {
            
            [_reusePoolCellAry addObject:_visibleCellDict[visibelCellKey[i]]];
            [_visibleCellDict removeObjectForKey:visibelCellKey[i]];
        }
    }
}

#pragma mark - 重用的根本方法  先从现有池拿,没有再从重用池拿,没有再创建
// 重用池Model/UI 和 现有池Model/UI
// 重用池和现有池有同一个 cellA，现有池的cellA 就会返回出来
- (__kindof UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath{
    
    // 1. 是否在现有池里面,如果有,从现有池里面读取对应的cell返回
    UITableViewCell *cell = _visibleCellDict[@(indexPath.row)];
    if(!cell){
        // 2. 现有池如没有，再看重用池
        // 2.1 重用池是否有没有用的cell,有就返回cell
        if(_reusePoolCellAry.count > 0){
            cell = _reusePoolCellAry.firstObject;
        
        }else{
        // 2.2 重用池没有就创建
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        // 2.3 保存到现有池,移除重用池
        [_visibleCellDict setObject:cell forKey:@(indexPath.row)];// 保存到现有池
        [_reusePoolCellAry removeObject:cell]; // 移除重用池
    }
    
    return cell;
}

#pragma mark - 二分查找查找索引操作
- (NSInteger)binarySerchOC:(NSArray*)dataAry target:(EOCCellModel*)targetModel{
    
    NSInteger min = 0;
    NSInteger max = dataAry.count - 1;
    NSInteger mid;
    while (min < max) {
        mid = min + (max - min)/2;
        // 条件判断
        EOCCellModel *midModel = dataAry[mid];
        if (midModel.y < targetModel.y && midModel.y + midModel.height > targetModel.y) {
            return mid;
        }else if(targetModel.y < midModel.y){
            max = mid;// 在左边
            if (max - min == 1) {
                return min;
            }
        }else {
            min = mid;// 在右边
            if (max - min == 1) {
                return max;
            }
        }
    }
    return -1;
}

@end
