//
//  ViewController.m
//  Graffiti
//
//  Created by 尤增强 on 2018/8/16.
//  Copyright © 2018年 zqyou. All rights reserved.
//

#import "ViewController.h"
#import "imgTrace.h"
#import "GraffitiBoardViewController.h"
@interface ViewController (){
    NSArray* list;
    NSArray* VClist;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    list = @[@"涂鸦",@"痕迹",@"主题更换"];

    [self setTableView];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)setTableView{
       [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MyCell"];
       self.tableView.tableFooterView = [[UIView alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return list.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell" forIndexPath:indexPath];
    NSString *name = list[indexPath.row];
    cell.textLabel.text = name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"%@", list[indexPath.row]);

    switch (indexPath.row) {
        case 0:{
                GraffitiBoardViewController *vc = [[GraffitiBoardViewController alloc] init];
                [self.navigationController pushViewController:vc animated:true];

                break;
             }
        case 1:{
                imgTrace *vc = [[imgTrace alloc] init];
                [self.navigationController pushViewController:vc animated:true];
                break;
            }

        default:
            NSLog(@"测试");
            break;
    }

}
@end
