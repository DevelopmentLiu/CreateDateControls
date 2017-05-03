//
//  ViewController.m
//  CreateDateControls
//
//  Created by hydom on 2017/5/2.
//  Copyright © 2017年 Liu. All rights reserved.
//

#import "ViewController.h"
#import "LJYDateControls.h"
#import "CollectionViewCell.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nowMouth;
@property (nonatomic, strong) LJYDateControls *calendar;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initCollectionView];
}


#pragma mark-- 

- (void)initCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置对齐方式
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //cell间距
    layout.minimumInteritemSpacing = 1.0f;
    //cell行距
    layout.minimumLineSpacing = 1.0f;
    
    _calendar = [[LJYDateControls alloc] initWithFrame:CGRectMake(0, 100, WIDTH, 252) collectionViewLayout:layout AndCellName:@"CollectionViewCell" AndCellID:@"collectionCell"] ;
    _nowMouth.text = [NSString stringWithFormat:@"%ld年%ld月%ld日",_calendar.year,_calendar.momth,_calendar.day];
    [self.view addSubview:_calendar];
}
- (IBAction)LastClick:(UIButton *)sender {
    [_calendar LastMonthClick];
    _nowMouth.text = [NSString stringWithFormat:@"%ld年%ld月%ld日",_calendar.year,_calendar.momth,_calendar.day];
}

- (IBAction)NextClick:(UIButton *)sender {
    [_calendar NextbuttonClick];
    _nowMouth.text = [NSString stringWithFormat:@"%ld年%ld月%ld日",_calendar.year,_calendar.momth,_calendar.day];
}

@end
