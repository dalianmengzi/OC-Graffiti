//
//  BoardSetting.m
//  Graffiti
//
//  Created by 尤增强 on 2018/9/19.
//  Copyright © 2018年 zqyou. All rights reserved.
//

#import "BoardSetting.h"
#import "BackImageBoard.h"
#import "UIView+Frame.h"
#import "BallColorModel.h"
static NSString * const collectionCellID = @"collectionCellID";

@interface BoardSetting() <UICollectionViewDataSource,UICollectionViewDelegate> {
    NSArray* list;
    NSIndexPath *_lastIndexPath;

}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *minWidth;
@property (weak, nonatomic) IBOutlet UIButton *secondWidth;
@property (weak, nonatomic) IBOutlet UIButton *thirdWidth;
@property (weak, nonatomic) IBOutlet UIButton *fourWidth;
@property (weak, nonatomic) IBOutlet UIButton *maxWidth;

@property (nonatomic, strong) ColorBall *ballView;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *colorSelectModels;

@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, assign) CGFloat currentLine;
@property (weak, nonatomic) IBOutlet UIButton *pen;
@property (weak, nonatomic) IBOutlet UIButton *save;
@property (weak, nonatomic) IBOutlet UIButton *clear;
@property (weak, nonatomic) IBOutlet UIButton *back;
@property (weak, nonatomic) IBOutlet UIButton *del;

@property (weak, nonatomic) IBOutlet UIButton *reset;

@property (weak, nonatomic) IBOutlet UIView *buttomView;
@property (nonatomic, copy) boardSettingBlock stype;
@property (weak, nonatomic) IBOutlet UIView *centerView;

@end
@implementation BoardSetting

- (void)awakeFromNib
{
    self.collectionView.backgroundColor = [UIColor clearColor];


    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionCellID];

    self.ballView = [[ColorBall alloc] init] ;
    self.centerView.hidden = self.collectionView.hidden = NO;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];


     list = @[self.minWidth, self.secondWidth,self.thirdWidth,self.fourWidth,self.maxWidth];

    for (UIButton *btn in list) {
           btn.layer.masksToBounds = YES;
           btn.layer.cornerRadius =  btn.frame.size.height / 2;
        }
    self.secondWidth.layer.borderWidth = 3;
    self.secondWidth.layer.borderColor = [UIColor whiteColor].CGColor;
    if (!_lastIndexPath){
        //设置默认是属性
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        self.currentLine = 4;
    }

}

- (void)getSettingType:(boardSettingBlock)type {

    self.stype = type;

}

- (CGFloat)getLineWidth {

    return self.currentLine;

}

- (UIColor *)getLineColor {

    return self.currentColor;

}



- (IBAction)penSetting:(id)sender {


    self.centerView.hidden = self.collectionView.hidden = NO;

    if (self.stype) {

        self.stype(setTypePen);

    }

}



- (IBAction)saveImage:(id)sender {

    if (self.stype) {
        self.stype(setTypeSave);
    }
}

- (IBAction)eraser:(id)sender {


    if (self.stype) {

        self.stype(setTypeEraser);

    }

}

- (IBAction)back:(id)sender {

    if (self.stype) {

        self.stype(setTypeBack);

    }

}

- (IBAction)revocation:(id)sender {

    if (self.stype) {

        self.stype(setTyperegeneration);

    }

}

- (IBAction)clearAll:(id)sender {

    if (self.stype) {

        self.stype(setTypeClearAll);

    }

}

- (IBAction)setlineWidth:(UIButton *)sender {

    self.currentLine = sender.tag - 1000;
    for (UIButton *btn in list) {
        if (sender == btn) {
            btn.layer.borderWidth = 3;
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
        }else{
            btn.layer.borderWidth = 0;
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SendColorAndWidthNotification object:nil];

}

-(void)setToolShadow:(UIButton *)sender{

}

#pragma mark - collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.colorSelectModels.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    BallColorModel *model = self.colorSelectModels[indexPath.item];
    cell.backgroundColor = self.colors[[model.ballColor integerValue]];
    cell.layer.cornerRadius = 3;

    if (model.isBallColor) {
        cell.layer.borderWidth = 3;
        cell.layer.borderColor = [UIColor whiteColor].CGColor;
    }else{
        cell.layer.borderWidth = 0;
    }
    cell.layer.masksToBounds = YES;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (_lastIndexPath) {
        BallColorModel *lastModel = self.colorSelectModels[_lastIndexPath.item];
        lastModel.isBallColor = NO;
        [self.collectionView reloadItemsAtIndexPaths:@[_lastIndexPath]];
    }
    _lastIndexPath = indexPath;


    BallColorModel *model = self.colorSelectModels[indexPath.item];

    self.currentColor = self.colors[[model.ballColor integerValue]];
    for (UIButton *btn in list) {
        btn.backgroundColor = self.currentColor;
    }
    model.isBallColor = YES;
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    self.stype(setTypeColor);
    [[NSNotificationCenter defaultCenter] postNotificationName:SendColorAndWidthNotification object:nil];

}

#pragma mark - lazy

- (NSArray *)colorSelectModels
{
    if (!_colorSelectModels) {
        //        isBallColor
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@(0),@"ballColor", nil];
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@(1),@"ballColor", nil];
        NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@(2),@"ballColor", nil];
        NSDictionary *dic4 = [NSDictionary dictionaryWithObjectsAndKeys:@(3),@"ballColor", nil];
        NSDictionary *dic5 = [NSDictionary dictionaryWithObjectsAndKeys:@(4),@"ballColor", nil];
        NSDictionary *dic6 = [NSDictionary dictionaryWithObjectsAndKeys:@(5),@"ballColor", nil];
        NSDictionary *dic7 = [NSDictionary dictionaryWithObjectsAndKeys:@(6),@"ballColor", nil];
        NSArray *array = [NSArray arrayWithObjects:dic1,
                          dic2,
                          dic3,
                          dic4,
                          dic5,
                          dic6,
                          dic7,
                          nil];
        _colorSelectModels = [BallColorModel mj_objectArrayWithKeyValuesArray:array];

    }

    return _colorSelectModels;

}

- (NSArray *)colors {

    if (!_colors) {

        _colors = [NSArray arrayWithObjects:
                   [UIColor colorWithRed:0.92 green:0.26 blue:0.27 alpha:1],
                   [UIColor colorWithRed:0.95 green:0.59 blue:0.28 alpha:1],
                   [UIColor colorWithRed:0.88 green:0.85 blue:0.25 alpha:1],
                   [UIColor colorWithRed:0.5 green:0.88 blue:0.25 alpha:1],
                   [UIColor colorWithRed:0.32 green:0.86 blue:0.87 alpha:1],
                   [UIColor colorWithRed:0.18 green:0.48 blue:0.88 alpha:1],
                   [UIColor colorWithRed:0.6 green:0.24 blue:0.88 alpha:1],
                   nil];

    }

    return _colors;

}

@end



