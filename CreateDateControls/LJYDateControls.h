//
//  LJYDateControls.h
//  CreateDateControls
//
//  Created by hydom on 2017/5/2.
//  Copyright © 2017年 Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJYDateControls : UICollectionView
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger momth;
@property (nonatomic, assign) NSInteger day;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout AndCellName:(NSString*)name AndCellID:(NSString*)cellID;
- (void)LastMonthClick;
- (void)NextbuttonClick;

@end
