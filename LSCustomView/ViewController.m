//
//  ViewController.m
//  LSCustomView
//
//  Created by LIUS on 16/6/20.
//  Copyright © 2016年 LIUS. All rights reserved.
//

#import "ViewController.h"
#import "LSCustomView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    LSCustomView *customView = [[LSCustomView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    [self.view addSubview:customView];
    CGFloat offsetX = 20;
    customView.trackPoints = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:CGPointMake(40+offsetX, 80)],
                              [NSValue valueWithCGPoint:CGPointMake(160+offsetX, 250)],
                              [NSValue valueWithCGPoint:CGPointMake(280+offsetX, 80)],
                              
                              [NSValue valueWithCGPoint:CGPointMake(80+offsetX, 30)],
                              nil];
    customView.cornerRadius = 10;
    customView.borderWidth = 20;
    customView.borderColor = [UIColor redColor];
    [customView setMask];
    customView.center = self.view.center;
    customView.backgroundColor = [UIColor purpleColor];
    customView.clipsToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dddddddd)];
    [customView addGestureRecognizer:tap];
    
    
    
}
                    


- (void)dddddddd{
    NSLog(@"%s",__func__);
}
@end
