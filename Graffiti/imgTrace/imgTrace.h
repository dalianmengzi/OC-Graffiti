//
//  imgTrace.h
//  Graffiti
//
//  Created by 尤增强 on 2018/9/18.
//  Copyright © 2018年 zqyou. All rights reserved.
//

#import <UIKit/UIKit.h>
@class imgTrace;
@interface imgTrace : UIViewController<UIGestureRecognizerDelegate,UIScrollViewDelegate>
{
    CGFloat lastScale;
    CGRect oldFrame;    //保存图片原来的大小
    CGRect largeFrame;  //确定图片放大最大的程度
}
@end
