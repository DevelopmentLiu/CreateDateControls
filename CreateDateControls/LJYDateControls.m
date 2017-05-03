//
//  LJYDateControls.m
//  CreateDateControls
//
//  Created by hydom on 2017/5/2.
//  Copyright © 2017年 Liu. All rights reserved.
//

#import "LJYDateControls.h"
#import "CollectionViewCell.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface LJYDateControls()<UICollectionViewDelegate,UICollectionViewDataSource>
/*
 ****用来存放天数的数组
 */
@property (nonatomic,strong)NSArray * weekArray;
@property (nonatomic,strong)NSMutableArray * dayArray;
@property (nonatomic,strong)NSDateComponents * nowDate;
@property (nonatomic,strong)NSCalendar *calendar;
@property (nonatomic,strong)NSDate *lastMonthDate;
@property (nonatomic,strong)NSDate *NowMonthfirst;

@property (nonatomic,copy)NSString * CellIds;
@end

@implementation LJYDateControls

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout AndCellName:(NSString *)name AndCellID:(NSString *)cellID
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        [self registerNib:[UINib nibWithNibName:name bundle:nil] forCellWithReuseIdentifier:cellID];
        self.CellIds = cellID;
        [self initDataSource];
    }
    return self;
}

#pragma mark-- 初始化数据
- (void)initDataSource{
    self.weekArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    self.dayArray = [NSMutableArray array];
    self.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.nowDate  =[self.calendar components:NSCalendarUnitYear|kCFCalendarUnitMonth|kCFCalendarUnitDay|NSCalendarUnitWeekday fromDate:[NSDate date]];
    self.year =  self.nowDate.year;
    self.momth = self.nowDate.month;
    self.day   = self.nowDate.day;
    [self setMydayArrayWithYear:_year AndMonth:_momth AndDay:_day];
}

//请求下一个月的数据
-(void)NextbuttonClick{
    
    [_dayArray removeAllObjects];
    if (_momth == 12) {
        _momth = 1;
        _year++;
    }else{
        _momth++;
    }
    [self setMydayArrayWithYear:_year AndMonth:_momth AndDay:_day];
    [self reloadData];
    
}
//请求上一个月的数据
-(void)LastMonthClick{
    
    [_dayArray removeAllObjects];
    
    if (_momth == 1) {
        _momth = 12;
        _year--;
    }else{
        _momth--;
    }
    [self setMydayArrayWithYear:_year AndMonth:_momth AndDay:_day];
    [self reloadData];
    
}


//请求数据
-(void)setMydayArrayWithYear:(NSInteger)year AndMonth:(NSInteger)month AndDay:(NSInteger)day{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * nowDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day]];
    NSRange dayRange = [_calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:nowDate];
    
    NSRange lastdayRange = [_calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[self setLastMonthWithYear:year AndMonth:month AndDay:day]];
    
    _NowMonthfirst = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%d",year,month,1]];
    NSDateComponents * components = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:_NowMonthfirst];
    
    NSDate * nextDay = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld",year,month,dayRange.length]];
    NSDateComponents * lastDay = [_calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:nextDay];
    
    for (NSInteger i = lastdayRange.length - components.weekday + 2; i <= lastdayRange.length; i++) {
        
        NSString * string = [NSString stringWithFormat:@"%ld",i];
        [_dayArray addObject:string];
    }
    for (NSInteger i = 1; i <= dayRange.length ; i++) {
        
        NSString * string = [NSString stringWithFormat:@"%ld",i];
        [_dayArray addObject:string];
    }
    for (NSInteger i = 1; i <= (7 - lastDay.weekday); i++) {
        
        NSString * string = [NSString stringWithFormat:@"%ld",i];
        [_dayArray addObject:string];
    }
}

- (NSDate*)setLastMonthWithYear:(NSInteger)year AndMonth:(NSInteger)month AndDay:(NSInteger)day{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = nil;
    if (month != 1) {
        
        date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld",year,month-1,day]];
        
    }else{
        
        date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%d-%ld",year,12,day]];
    }
    return date;
}

#pragma mark-- UICollectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dayArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((WIDTH-26)/7,(WIDTH-26)/7);
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.CellIds forIndexPath:indexPath];
    cell.cellLabel.text = self.dayArray[indexPath.row];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor cyanColor];
    return cell;
}
//调整Item的位置 使Item不紧挨着屏幕
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //在原有基础上进行调整 上 左 下 右
    return UIEdgeInsetsMake(1, 5, 0, 5);
}
//设置水平间距与竖直间距 默认为10
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
    
}


@end
