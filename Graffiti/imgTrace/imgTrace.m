//
//  imgTrace.m
//  Graffiti
//
//  Created by 尤增强 on 2018/9/18.
//  Copyright © 2018年 zqyou. All rights reserved.
//

#import "imgTrace.h"
#import "BoardSetting.h"
#import "CustomWindow.h"
#import "JessicaActionSheet.h"
#import "BaseBrush.h"
#import "DrawCommon.h"
#import "PaintingView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface imgTrace ()

@property (weak, nonatomic) IBOutlet PaintingView *drawView;
@property (weak, nonatomic) IBOutlet UIImageView *Img;

    @property (nonatomic, strong) BoardSetting *settingBoard;
    @property (nonatomic, strong) CustomWindow *drawWindow;
   
    @property (nonatomic, strong) JessicaActionSheet *pencilActionSheet;
    @property (nonatomic, strong) JessicaActionSheet *cleanActionSheet;
@end

@implementation imgTrace

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"痕迹";

    [self addObserver];

    [self setupPaintBrush];

    [self creatRightBarButtonItem];

    [self showSettingBoard];

    NSURL *imgURL = [NSURL URLWithString:@"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=69342389,1062770408&fm=173&app=25&f=JPG?w=640&h=363&s=0C82E3155E014A4D07B6A3C10300308E"];


    [self.Img sd_setImageWithURL:imgURL
                      placeholderImage:nil
                               options:SDWebImageRefreshCached
                              progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {

                              }
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 //                                 weakSelf.progressView.hidden = YES;
                                 NSLog(@"----图片加载完毕---%@", image);
                                 self.drawView.backgroundImage = image;
                             }];



    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupPaintBrush {

    self.drawView.paintBrush = [BaseBrush brushWithType:BrushTypePencil];
    self.drawView.paintBrush.lineWidth = self.settingBoard.getLineWidth;
    self.drawView.paintBrush.lineColor = self.settingBoard.getLineColor;
//    self.drawView.backgroundImage = [UIImage imageNamed:@"保存"];
//    self.delegate = self;


}


- (void)addObserver {

    [[NSNotificationCenter defaultCenter] addObserverForName:ImageBoardNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {

        NSString *str = [note.userInfo objectForKey:@"imageBoardName"];

        dispatch_async(dispatch_get_main_queue(), ^{

            self.drawView.backgroundImage = [UIImage imageNamed:str];

        });

    }];

    [[NSNotificationCenter defaultCenter] addObserverForName:SendColorAndWidthNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {

        dispatch_async(dispatch_get_main_queue(), ^{

            self.drawView.paintBrush.lineWidth = self.settingBoard.getLineWidth;
            self.drawView.paintBrush.lineColor = self.settingBoard.getLineColor;

        });


    }];

}
- (void)creatRightBarButtonItem {

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"工具箱" style:UIBarButtonItemStyleBordered target:self action:@selector(rightAction)];

    self.navigationItem.rightBarButtonItem = rightItem;

}

- (void)rightAction {

    [self showSettingBoard];

}

- (BoardSetting *)settingBoard
{
    if (!_settingBoard) {

        _settingBoard = [[[NSBundle mainBundle] loadNibNamed:@"BoardSetting" owner:nil options:nil] firstObject];
        _settingBoard.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 191);

        __weak typeof(self) weakSelf = self;

        [_settingBoard getSettingType:^(setType type) {

            switch (type) {
                case setTypePen:
                {

                    [weakSelf hideSettingBoard];

                    if (!weakSelf.pencilActionSheet) {

                        weakSelf.pencilActionSheet = [[JessicaActionSheet alloc] initWithTitle:@"画笔类型" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"画笔",@"直线",@"虚线",@"矩形",@"方形",@"椭圆",@"正圆",@"箭头", nil];

                        [weakSelf.pencilActionSheet setTitleColor:[UIColor orangeColor] fontSize:20];

                    }

                    [weakSelf.pencilActionSheet show];

                }
                    break;
                case setTypeCamera:
                {
                    [weakSelf hideSettingBoard];

//                    if ([self.delegate respondsToSelector:@selector(drawView:action:)]) {
//                        [self.delegate drawView:self action:actionOpenCamera];
//                    }

                }
                    break;
                case setTypeAlbum:
                {

                    [weakSelf hideSettingBoard];

//                    if ([self.delegate respondsToSelector:@selector(drawView:action:)]) {
//                        [self.delegate drawView:self action:actionOpenAlbum];
//                    }
                }
                    break;
                case setTypeSave:
                {
                    [self.drawView saveToPhotosAlbum];

                }
                    break;
                case setTypeEraser:
                {
                    [weakSelf hideSettingBoard];
                    id<PaintBrush> paintBrush;
                    paintBrush = [BaseBrush brushWithType:BrushTypeEraser];
                    paintBrush.lineWidth = weakSelf.settingBoard.getLineWidth;
                    paintBrush.lineColor = weakSelf.settingBoard.getLineColor;
                    weakSelf.drawView.paintBrush = paintBrush;
                }
                    break;
                case setTypeBack:
                {
                    //                     [weakSelf hideSettingBoard];
                    if(weakSelf.drawView.canUndo) {

                        [weakSelf.drawView undo];

                    }

                }
                    break;
                case setTyperegeneration:
                {
                    //                     [weakSelf hideSettingBoard];
                    if(weakSelf.drawView.canRedo) {

                        [weakSelf.drawView redo];

                    }
                }
                    break;
                case setTypeClearAll:
                {

                    [weakSelf hideSettingBoard];

                    if (!weakSelf.cleanActionSheet) {

                        weakSelf.cleanActionSheet = [[JessicaActionSheet alloc] initWithTitle:@"清除方式" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"仅清除画笔",@"仅清除背景",@"全部清除", nil];

                        [weakSelf.cleanActionSheet setTitleColor:[UIColor orangeColor] fontSize:20];

                    }

                    [weakSelf.cleanActionSheet show];

                }
                    break;
                case setTypeColor:
                {
                    [weakSelf hideSettingBoard];
                }
                default:
                    break;
            }
        }];

    }

    return _settingBoard;

}

#pragma mark - JessicaActionSheet

- (void)actionSheetCancel:(JessicaActionSheet *)actionSheet {

    if (actionSheet == self.pencilActionSheet) {

    }else if (actionSheet == self.cleanActionSheet) {

    }

}

- (void)actionSheet:(JessicaActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex {

    if (sheet == self.pencilActionSheet) {

        id<PaintBrush> paintBrush;

        switch (buttonIndex) {
            case 0:
                paintBrush = [BaseBrush brushWithType:BrushTypePencil];
                break;
            case 1:
                paintBrush = [BaseBrush brushWithType:BrushTypeLine];
                break;
            case 2:
                paintBrush = [BaseBrush brushWithType:BrushTypeDashLine];
                break;
            case 3:
                paintBrush = [BaseBrush brushWithType:BrushTypeRectangle];
                break;
            case 4:
                paintBrush = [BaseBrush brushWithType:BrushTypeSquare];
                break;
            case 5:
                paintBrush = [BaseBrush brushWithType:BrushTypeEllipse];
                break;
            case 6:
                paintBrush = [BaseBrush brushWithType:BrushTypeCircle];
                break;
            case 7:
                paintBrush = [BaseBrush brushWithType:BrushTypeArrow];
                break;
            default:
                break;
        }

        paintBrush.lineWidth = self.settingBoard.getLineWidth;
        paintBrush.lineColor = self.settingBoard.getLineColor;

        self.drawView.paintBrush = paintBrush;


    }else if (sheet == self.cleanActionSheet) {

        switch (buttonIndex) {
            case 0:
                [self.drawView clear];
                break;
            case 1:
                self.drawView.backgroundImage = nil;
                break;
            case 2:
                self.drawView.backgroundImage = nil;
                [self.drawView clear];
                break;
            default:
                break;
        }

    }

}

#pragma mark - SettingBoard

- (CustomWindow *)drawWindow {

    if (!_drawWindow) {

        _drawWindow = [[CustomWindow alloc] initWithAnimationView:self.settingBoard];

    }

    return _drawWindow;

}

- (void)showSettingBoard {

    [self.drawWindow showWithAnimationTime:0.25];

}

- (void)hideSettingBoard {

    [self.drawWindow hideWithAnimationTime:0.25];

}

#pragma mark - Dealloc

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:ImageBoardNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:SendColorAndWidthNotification object:nil];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
