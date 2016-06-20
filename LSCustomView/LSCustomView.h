//
//  LSCustomView.h
//  LSCustomView
//
//  Created by LIUS on 16/6/20.
//  Copyright © 2016年 LIUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface LSCustomView : UIView 

@property (nonatomic, strong) NSMutableArray *trackPoints;
@property (nonatomic, readwrite) UIBezierPath *tempPath;
@property (nonatomic, readwrite) float cornerRadius;
@property (nonatomic, readwrite) float borderWidth;
@property (nonatomic, readwrite) UIColor *borderColor;

- (void)setMask;
@end
