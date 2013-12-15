//
//  TTPieceView.m
//  Konker
//
//  Created by Wan Ahmad Lutfi Wan Md Hatta on 14/12/13.
//  Copyright (c) 2013 wan. All rights reserved.
//

#import "TTPieceView.h"

@interface TTPieceView ()

@property (nonatomic, strong) CAShapeLayer *penLayer;

@end

@implementation TTPieceView
{
    UIColor *_color;
}

- (id)initWithFrame:(CGRect)frame color:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _color = color;
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}


- (CAShapeLayer*)penLayer
{
    if (!_penLayer) {
        _penLayer = [CAShapeLayer layer];
        _penLayer.lineWidth = 2.5;
        _penLayer.frame = self.bounds;
        _penLayer.fillColor = [UIColor clearColor].CGColor;
    
        [self.layer addSublayer:_penLayer];
    }
    return _penLayer;
}


//!play pen stroke animation just to make it more beautiful, can just use simple shape or image actually.
- (void)playPenLayerAnimation{
    self.penLayer.strokeColor = _color.CGColor;
    self.penLayer.path = [self penStrokePath].CGPath;
    
    //random duration for path animation
    CGFloat randomDuration = 0.3 + (arc4random() / RAND_MAX)*0.5; //random duration  from 0.3 - 0.8;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = randomDuration;
    pathAnimation.fromValue = @(0.0f);
    pathAnimation.toValue = @(1.0f);
    [self.penLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    //rotate and scale so all piece dont seems equal
    CGFloat randomXScale = 0.7 + (arc4random() / RAND_MAX) * 0.2; //get random scale from 0.7 to 0.9 for x
    CGFloat randomYScale = 0.7 + (arc4random() / RAND_MAX) * 0.2; //get random scale from 0.7 to 0.9 for y
    CATransform3D rotateTransform = CATransform3DMakeRotation(arc4random(), 0.0, 0.0, 1.0);
    CATransform3D scaleTransform = CATransform3DMakeScale(randomXScale, randomYScale, 1);
    
    CATransform3D bothTransform = CATransform3DConcat(rotateTransform, scaleTransform);
    self.penLayer.transform = bothTransform;
 //use arc4random for random angle, because dont need specific angle
}


- (UIBezierPath*)penStrokePath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGRect bounds = self.bounds;
    
    //Curve path
    CGPoint p1 = WLPointForRectAndAttributeWithFactor(bounds, kRectLowerLeft, CGPointMake(.358, .492));
    CGPoint p2 = WLPointForRectAndAttributeWithFactor(bounds, kRectUpperRight, CGPointMake(.125, .32));
    CGPoint p3 = WLPointForRectAndAttributeWithFactor(bounds, kRectLowerRight, CGPointMake(.136, .406));
    CGPoint p4 = WLPointForRectAndAttributeWithFactor(bounds, kRectLowerRight, CGPointMake(.276, .192));
    CGPoint p5 = WLPointForRectAndAttributeWithFactor(bounds, kRectLowerLeft, CGPointMake(.211, .171));
    CGPoint p6 = WLPointForRectAndAttributeWithFactor(bounds, kRectUpperLeft, CGPointMake(.246, .287));
    CGPoint p7 = WLPointForRectAndAttributeWithFactor(bounds, kRectUpperLeft, CGPointMake(.434, .105));
    CGPoint p8 = WLPointForRectAndAttributeWithFactor(bounds, kRectUpperRight, CGPointMake(.084, .339));
    CGPoint p9 = WLPointForRectAndAttributeWithFactor(bounds, kRectLowerLeft, CGPointMake(.429, .131));
    CGPoint p10 = WLPointForRectAndAttributeWithFactor(bounds, kRectLowerLeft, CGPointMake(.336, .283));
    CGPoint p11 = WLPointForRectAndAttributeWithFactor(bounds, kRectUpperLeft, CGPointMake(.289, .13));
    CGPoint p12 = WLPointForRectAndAttributeWithFactor(bounds, kRectUpperLeft, CGPointMake(.419, .078));
    CGPoint p13 = WLPointForRectAndAttributeWithFactor(bounds, kRectUpperRight, CGPointMake(.241, .377));
    CGPoint p14 = WLPointForRectAndAttributeWithFactor(bounds, kRectLowerRight, CGPointMake(.2, .374));
    CGPoint p15 = WLPointForRectAndAttributeWithFactor(bounds, kRectLowerLeft, CGPointMake(.347, .218));
    CGPoint p16 = WLPointForRectAndAttributeWithFactor(bounds, kRectUpperLeft, CGPointMake(.382, .188));
    CGPoint p17 = WLPointForRectAndAttributeWithFactor(bounds, kRectUpperRight, CGPointMake(.412, .09));
    CGPoint p18 = WLPointForRectAndAttributeWithFactor(bounds, kRectUpperRight, CGPointMake(.153, .286));
    CGPoint p19 = WLPointForRectAndAttributeWithFactor(bounds, kRectLowerRight, CGPointMake(.105, .309));
    CGPoint p20 = WLPointForRectAndAttributeWithFactor(bounds, kRectLowerLeft, CGPointMake(.253, .205));
    CGPoint p21 = WLPointForRectAndAttributeWithFactor(bounds, kRectUpperLeft, CGPointMake(.198, .317));
    CGPoint p22 = WLPointForRectAndAttributeWithFactor(bounds, kRectUpperRight, CGPointMake(.33, .363));
    CGPoint p23 = WLPointForRectAndAttributeWithFactor(bounds, kRectLowerRight, CGPointMake(.383, .48));
    CGPoint p24 = WLPointForRectAndAttributeWithFactor(bounds, kRectUpperRight, CGPointMake(.476, .299));
    CGPoint p25 = WLPointForRectAndAttributeWithFactor(bounds, kRectUpperRight, CGPointMake(.159, .279));
    CGPoint p26 = WLPointForRectAndAttributeWithFactor(bounds, kRectLowerRight, CGPointMake(.306, .414));
    CGPoint p27 = WLPointForRectAndAttributeWithFactor(bounds, kRectLowerLeft, CGPointMake(.376, .414));
    
    [path moveToPoint:p1];
    [path addLineToPoint:p2];
    [path addLineToPoint:p3];
    [path addLineToPoint:p4];
    [path addLineToPoint:p5];
    [path addLineToPoint:p6];
    [path addLineToPoint:p7];
    [path addLineToPoint:p8];
    [path addLineToPoint:p9];
    [path addLineToPoint:p10];
    [path addLineToPoint:p11];
    [path addLineToPoint:p12];
    [path addLineToPoint:p13];
    [path addLineToPoint:p14];
    [path addLineToPoint:p15];
    [path addLineToPoint:p16];
    [path addLineToPoint:p17];
    [path addLineToPoint:p18];
    [path addLineToPoint:p19];
    [path addLineToPoint:p20];
    [path addLineToPoint:p21];
    [path addLineToPoint:p22];
    [path addLineToPoint:p23];
    [path addLineToPoint:p24];
    [path addLineToPoint:p25];
    [path addLineToPoint:p26];
    [path addLineToPoint:p27];
    [path addLineToPoint:p1];


    
    return path;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
