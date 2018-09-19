//
//  BoardSetting.h
//  Graffiti
//
//  Created by 尤增强 on 2018/9/19.
//  Copyright © 2018年 zqyou. All rights reserved.
//

#import <UIKit/UIKit.h>



#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,setType) {
    setTypePen,
    setTypeCamera,
    setTypeAlbum,
    setTypeSave,
    setTypeEraser,
    setTypeBack,
    setTyperegeneration,
    setTypeClearAll,
    setTypeColor
};

typedef void(^boardSettingBlock)(setType type);

@interface BoardSetting : UIView

- (void)getSettingType:(boardSettingBlock)type;
- (CGFloat)getLineWidth;
- (UIColor *)getLineColor;

@end

//画笔展示的球
@interface ColorBall : UIView

@property (nonatomic, strong) UIColor *ballColor;
@property (nonatomic, assign) CGFloat ballSize;
@property (nonatomic, assign) CGFloat lineWidth;

@end
