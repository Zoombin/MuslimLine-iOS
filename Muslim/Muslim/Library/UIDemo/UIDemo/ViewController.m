//
//  ViewController.m
//  UIDemo
//
//  Created by 颜超 on 15/12/17.
//  Copyright © 2015年 Yc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    NSString *titleContent = @"عربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربيةعربية";
    titleLabel.text = titleContent;
    titleLabel.numberOfLines = 0;//多行显示，计算高度
    titleLabel.backgroundColor = [UIColor blackColor];
    titleLabel.textColor = [UIColor lightGrayColor];
    CGSize titleSize = [titleContent boundingRectWithSize:CGSizeMake(320, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
//    titleLabel.size = titleSize;
//    titleLabel.x = 0;
//    titleLabel.y = 0;
    
    titleLabel.frame = CGRectMake(0, 50, 320, titleSize.height);
    
    [self.view addSubview:titleLabel];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
