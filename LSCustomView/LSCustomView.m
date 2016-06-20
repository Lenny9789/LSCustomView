//
//  LSCustomView.m
//  LSCustomView
//
//  Created by LIUS on 16/6/20.
//  Copyright © 2016年 LIUS. All rights reserved.
//

#import "LSCustomView.h"

@interface LSCustomView()
<
UIGestureRecognizerDelegate
>

@end

@implementation LSCustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setMask{
    self.tempPath = [[UIBezierPath alloc] init];
    
    if (self.cornerRadius>0) {
        //calculate the Turning point of every corner.
        NSMutableArray *muaarray = [NSMutableArray array];
        for (int i=0; i < [self.trackPoints count]; i++) {
            CGPoint pointStart, pointEnd;
            if (i<[self.trackPoints count]-1) {
                pointStart = [[self.trackPoints objectAtIndex:i] CGPointValue];
                pointEnd = [[self.trackPoints objectAtIndex:i+1] CGPointValue];
            }else if (i==[self.trackPoints count]-1) {
                pointStart = [[self.trackPoints objectAtIndex:i] CGPointValue];
                pointEnd = [[self.trackPoints objectAtIndex:0] CGPointValue];
            }
            [muaarray addObject:[NSValue valueWithCGPoint:pointStart]];
            
            if (pointStart.x == pointEnd.x) {
                BOOL boolY = pointEnd.y-pointStart.y>0;
                pointStart.y = pointStart.y + self.cornerRadius*(boolY? 1 : -1);
                pointEnd.y = pointEnd.y - self.cornerRadius*(boolY? 1 : -1);
                
            }else if (pointStart.y == pointEnd.y){
                BOOL boolX = pointEnd.x-pointStart.x>0;
                pointStart.x = pointStart.x + self.cornerRadius*(boolX? 1 : -1);
                pointEnd.x = pointEnd.x - self.cornerRadius*(boolX? 1 : -1);
            }else{
                float tempL = (pointEnd.y-pointStart.y)/(pointEnd.x-pointStart.x);
                float cutX = sqrtf(self.cornerRadius*self.cornerRadius/(1+tempL*tempL));
                float cutY = fabsf(cutX*tempL);
                
                BOOL boolX = pointEnd.x-pointStart.x>0;
                BOOL boolY = pointEnd.y-pointStart.y>0;
                
                pointStart.x = pointStart.x + cutX*(boolX? 1 : -1);
                pointStart.y = pointStart.y + cutY*(boolY? 1 : -1);
                pointEnd.x = pointEnd.x - cutX*(boolX? 1 : -1);
                pointEnd.y = pointEnd.y - cutY*(boolY? 1 : -1);
            }
            [muaarray addObject:[NSValue valueWithCGPoint:pointStart]];
            [muaarray addObject:[NSValue valueWithCGPoint:pointEnd]];
        }
        
        //calculate the control point of every corner.
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 1; i<[muaarray count]; i=i+3) {
            CGPoint firstP;
            CGPoint nextP;
            CGPoint pointP;
            if (i<[muaarray count]-3) {
                firstP = [[muaarray objectAtIndex:i+1] CGPointValue];
                nextP  = [[muaarray objectAtIndex:i+3] CGPointValue];
                pointP  = [[muaarray objectAtIndex:i+2] CGPointValue];
            }else if (i==[muaarray count]-2){
                firstP = [[muaarray objectAtIndex:i+1] CGPointValue];
                nextP  = [[muaarray objectAtIndex:1] CGPointValue];
                pointP  = [[muaarray objectAtIndex:0] CGPointValue];
            }
            [arrayM addObject:[NSValue valueWithCGPoint:firstP]];
            [arrayM addObject:[NSValue valueWithCGPoint:pointP]];
            [arrayM addObject:[NSValue valueWithCGPoint:nextP]];
        }
        
        //set the path of maskLayer.
        for (int i=0; i <[arrayM count]; i=i+3) {
            CGPoint pathPoint = [[arrayM objectAtIndex:i] CGPointValue];
            if (i==0) {
                [self.tempPath moveToPoint:pathPoint];
            }else{
                [self.tempPath addLineToPoint:pathPoint];
            }
            
            CGPoint cPoint = [[arrayM objectAtIndex:i+1] CGPointValue];
            CGPoint endPoint = [[arrayM objectAtIndex:i+2] CGPointValue];
            [self.tempPath addQuadCurveToPoint:endPoint controlPoint:cPoint];
            
            if (i==[arrayM count]-3){
                pathPoint = [[arrayM objectAtIndex:0] CGPointValue];
                [self.tempPath addLineToPoint:pathPoint];
            }
        }
    }else{
        //set the path of maskLayer.
        for (int i=0; i <[self.trackPoints count]; i++) {
            CGPoint pathPoint = [[self.trackPoints objectAtIndex:i] CGPointValue];
            if (i==0) {
                [self.tempPath moveToPoint:pathPoint];
            }else{
                [self.tempPath addLineToPoint:pathPoint];
            }
            
            if (i==[self.trackPoints count]-1) {
                pathPoint = [[self.trackPoints objectAtIndex:0] CGPointValue];
                [self.tempPath addLineToPoint:pathPoint];
            }
        }
    }
    
    
    //do mask action.
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [self.tempPath CGPath];
    maskLayer.fillColor = [[UIColor whiteColor] CGColor];
    maskLayer.frame = self.frame;
    
    self.layer.mask = maskLayer;
    
    CAShapeLayer *maskBorderLayer = [CAShapeLayer layer];
    maskBorderLayer.path = [self.tempPath CGPath];
    maskBorderLayer.fillColor = [[UIColor clearColor] CGColor];
    maskBorderLayer.strokeColor = [self.borderColor CGColor];
    maskBorderLayer.lineWidth = self.borderWidth;
    [self.layer addSublayer:maskBorderLayer];
    
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
////    NSLog(@"%@",touches);
////    NSLog(@"%f",[[touches anyObject]locationInView:self].x);
//    CGPoint point = [[touches anyObject]locationInView:self];
//    if ([self.tempPath containsPoint:point]) {
//        NSLog(@"%s",__func__);
//        
//    }else{
//        return;
//    }
//}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if ([self.tempPath containsPoint:point]) {
        return YES;
    }else{
        return NO;
    }
}

@end
