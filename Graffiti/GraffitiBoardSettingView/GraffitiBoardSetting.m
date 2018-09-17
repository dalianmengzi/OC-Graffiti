//
//  GraffitiBoardSetting.m
//  UPOC_Teacher
//
//  Created by Jessica on 16/1/3.
//  Copyright © 2016年 北京新东方教育科技(集团)有限公司. All rights reserved.
//

#import "GraffitiBoardSetting.h"
#import "BackImageBoard.h"
#import "UIView+Frame.h"
#import "BallColorModel.h"

static NSString * const collectionCellID = @"collectionCellID";

@interface GraffitiBoardSetting() <UICollectionViewDataSource,UICollectionViewDelegate> {
    
    NSIndexPath *_lastIndexPath;
    
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionImageBoardView;
@property (weak, nonatomic) IBOutlet ColorBall *ballView;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *colorSelectModels;
@property (weak, nonatomic) IBOutlet UIButton *pickImageButton;
@property (weak, nonatomic) IBOutlet BackImageBoard *backImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomViewH;
@property (weak, nonatomic) IBOutlet UIView *buttomView;
@property (nonatomic, copy) boardSettingBlock stype;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UISlider *sliderView;
@end

@implementation GraffitiBoardSetting

- (void)awakeFromNib
{
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.pickImageButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.collectionImageBoardView.backgroundColor = self.backImageView.backgroundColor;
    
    [self.collectionImageBoardView registerNib:[UINib nibWithNibName:@"BackImageBoardCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:CollectionImageBoardViewID];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionCellID];
    
    self.backImageView.collectionView = self.collectionImageBoardView;
    
    self.backImageView.hidden = YES;
    self.centerView.hidden = self.collectionView.hidden = NO;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat normalW = self.width * 0.25;
    
    UIButton *btn = [self.buttomView.subviews firstObject];
    
    self.buttomViewH.constant = normalW * btn.currentImage.size.height / btn.currentImage.size.width;
    
    if (!_lastIndexPath){
        //设置默认是属性
        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        self.ballView.ballSize = 0;
    }
    
}

- (void)getSettingType:(boardSettingBlock)type {
    
    self.stype = type;

}

- (CGFloat)getLineWidth {
    
    return self.ballView.lineWidth;

}

- (UIColor *)getLineColor {
    
    return self.ballView.ballColor;

}

- (IBAction)penSetting:(id)sender {
    
    self.backImageView.hidden = YES;
    self.centerView.hidden = self.collectionView.hidden = NO;
    
    if (self.stype) {
    
        self.stype(setTypePen);

    }

}

- (IBAction)openCamera:(id)sender {
    
    if (self.stype) {
        
        self.stype(setTypeCamera);
        
    }
    
}

- (IBAction)openAlbum:(UIButton *)sender {
    
    
    self.backImageView.hidden = NO;
    
    self.centerView.hidden = self.collectionView.hidden = YES;
    
    if (sender.tag) return;
    
    if (self.stype) {
        
        self.stype(setTypeAlbum);
        
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

- (IBAction)sliderView:(UISlider *)sender {
    
    self.ballView.ballSize = sender.value;
    
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
        cell.layer.borderColor = [UIColor purpleColor].CGColor;
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
    self.ballView.ballColor = self.colors[[model.ballColor integerValue]];;
    model.isBallColor = YES;
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
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

@implementation ColorBall

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 0);
    
    CGContextSetStrokeColorWithColor(context, self.ballColor.CGColor);
    
    CGContextAddArc(context, self.centerX, self.centerY, self.centerX, 0, 2 * M_PI, 0);
    
    CGContextSetFillColorWithColor(context, self.ballColor.CGColor);
    
    CGContextAddEllipseInRect(context, self.bounds);
    
    CGContextDrawPath(context, kCGPathFill);
    
}

- (void)setBallColor:(UIColor *)ballColor {
    
    _ballColor = ballColor;
    
    [self setNeedsDisplay];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SendColorAndWidthNotification object:nil];

}

- (void)setBallSize:(CGFloat)ballSize
{
    _ballSize = ballSize;
    
    //缩放
    CGFloat vaule = 0.3 * (1 - ballSize) + ballSize;
    
    self.transform = CGAffineTransformMakeScale(vaule, vaule);
    
    self.lineWidth = self.width / 2.0;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SendColorAndWidthNotification object:nil];
    
}
@end
