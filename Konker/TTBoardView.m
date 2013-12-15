//
//  TTBoardView.m
//  Konker
//
//  Created by Wan Ahmad Lutfi Wan Md Hatta on 11/12/13.
//  Copyright (c) 2013 wan. All rights reserved.
//

#import "TTBoardView.h"
#import "TTPieceView.h"

@interface TTBoardView ()

//!all player 1 connected points use this layer to show connected points
@property (nonatomic, strong) CAShapeLayer *p1ConnectedLineLayer;
//!all player 2 connected points use this layer to show connected points
@property (nonatomic, strong) CAShapeLayer *p2ConnectedLineLayer;

@end

@implementation TTBoardView{
    CGFloat _upperMargin;

}

CGFloat CGPointDistance(CGPoint a, CGPoint b) {
    return sqrtf((a.x-b.x)*(a.x-b.x) + (a.y-b.y)*(a.y-b.y));
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    _numberOfRow = 35;
    _numberOfColumn = 30;
    _upperMargin = 100;
    _player1Color = [UIColor redColor];
    _player2Color = [UIColor blueColor];
    
    //create pan gesture so that view can track finger continously
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.maximumNumberOfTouches = 1; //only one touch is needed
    [self addGestureRecognizer:panGesture];
    
    //create pan gesture so that view can track finger continously
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tapGesture];
}

#pragma mark Draw

//!Draw board
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect bounds = self.bounds;
    CGFloat upperMargin = _upperMargin;
    CGFloat gridLength = CGRectGetWidth(bounds)/(CGFloat)_numberOfColumn;
    CGSize boardSize = [self boardSize];
    
    //add upper line so look like math book
    CGContextMoveToPoint(context, 0, upperMargin - 5);
    CGContextAddLineToPoint(context, self.bounds.size.width, upperMargin - 5);
    
    //draw lines
    NSUInteger i;
    for (i=0; i<=_numberOfColumn; i++) {
        CGContextMoveToPoint(context, i*gridLength, upperMargin);
        CGContextAddLineToPoint(context, i*gridLength, boardSize.height+ upperMargin);
    }
    for (i=0; i<=_numberOfRow; i++) {
        CGContextMoveToPoint(context, 0, i*gridLength + upperMargin);
        CGContextAddLineToPoint(context, self.bounds.size.width, i*gridLength + upperMargin);
    }
    CGContextSetRGBStrokeColor(context, 0, 0, 0.5, 1.0); //set blue color
    CGContextSetLineWidth(context, 0.5);
    CGContextStrokePath(context);
    // Drawing code
}

- (CAShapeLayer*)p1ConnectedLineLayer
{
    if (!_p1ConnectedLineLayer) {
        _p1ConnectedLineLayer = [CAShapeLayer layer];
//        _p1ConnectedLineLayer.delegate = self;
        _p1ConnectedLineLayer.lineWidth = 2;
        _p1ConnectedLineLayer.fillColor = [UIColor clearColor].CGColor;
        _p1ConnectedLineLayer.frame = self.frame;
        _p1ConnectedLineLayer.path = [UIBezierPath bezierPath].CGPath; //need initialize path first before use
        _p1ConnectedLineLayer.strokeColor = [self player1Color].CGColor;
        
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//        animation.duration = [CATransaction animationDuration];
//        animation.timingFunction = [CATransaction animationTimingFunction];
//        
//        NSDictionary *actions = @{@"strokeEnd": animation};
//        _p1ConnectedLineLayer.actions = actions;
        
        [self.layer addSublayer:_p1ConnectedLineLayer];
        
    }
    return _p1ConnectedLineLayer;
}

- (CAShapeLayer*)p2ConnectedLineLayer
{
    if (!_p2ConnectedLineLayer) {
        _p2ConnectedLineLayer = [CAShapeLayer layer];
//        _p2ConnectedLineLayer.delegate = self;
        _p2ConnectedLineLayer.lineWidth = 2;
        _p2ConnectedLineLayer.fillColor = [UIColor clearColor].CGColor;
        _p2ConnectedLineLayer.frame = self.frame;
        _p2ConnectedLineLayer.path = [UIBezierPath bezierPath].CGPath; //need initialize path first before use
        _p2ConnectedLineLayer.strokeColor = [self player2Color].CGColor;
        
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//        animation.duration = 7;
//        animation.timingFunction = [CATransaction animationTimingFunction];
//        
//        NSDictionary *actions = @{@"strokeEnd": animation};
//        _p1ConnectedLineLayer.actions = actions;
        
        [self.layer addSublayer:_p2ConnectedLineLayer];
        
    }
    return _p2ConnectedLineLayer;
}

#pragma mark Method

- (CGSize)boardSize
{
    CGRect bounds = self.bounds;
    CGFloat gridLength = CGRectGetWidth(bounds)/(CGFloat)_numberOfColumn;
    return CGSizeMake(gridLength*_numberOfColumn, gridLength*_numberOfRow);
}

- (CGPoint)viewPointForCoordinate:(CGPoint)coordinate
{
    CGSize boardSize = [self boardSize];
    CGFloat heightPerRow = boardSize.height / _numberOfRow;
    CGFloat widthPerCol = boardSize.width / _numberOfColumn;
    
    //get real point in board, need minus half of board size because of coordinate
    CGPoint point = CGPointMake(coordinate.x*widthPerCol, coordinate.y*heightPerRow );
    
    
    //add margin so get the point correctly
    point.y += _upperMargin;
    
    return point;
}

/**
 *  Get neares board coordinate with given point, this is to ensure a coordinate is touch.
 *
 *  @param point point in view
 *
 *  @return return nearest board coordinate with given point
 */
- (CGPoint)nearestBoardCoordinateForPoint:(CGPoint)point
{
    CGFloat nearestRow = -1, nearestCol = -1;
    CGFloat lowestDistance = INFINITY;
    
    for (NSUInteger i=0; i<_numberOfRow; i++) {
        for (NSUInteger j=0; j<_numberOfColumn; j++) {
            //compare distance
            CGPoint currentPoint = [self viewPointForCoordinate:CGPointMake(j, i)];
            CGFloat distance = CGPointDistance(point, currentPoint);
            
            //update nearest row and cl
            if (distance < lowestDistance) {
                lowestDistance = distance;
                nearestRow = i;
                nearestCol = j;
            }
        }
    }
    return CGPointMake(nearestCol, nearestRow);
}


#pragma mark Move

/**
 *  Move at given coordinate. Move verification has been done by TTBoard so in this method just move at given coordinatre
 *
 *  @param coordinate  coordinate for move
 *  @param playerIndex player index, 0 and 1 for player 1 and 2 respectively
 */
- (void)moveAtCoordinate:(CGPoint)coordinate forPlayerIndex:(NSInteger)playerIndex{
    
    //get color for specified player
    UIColor *color = playerIndex == 0 ? self.player1Color : self.player2Color;
    
    TTPieceView *pieceView = [[TTPieceView alloc] initWithFrame:CGRectMake(0, 0, 15, 15) color:color];
    pieceView.center = [self viewPointForCoordinate:coordinate];
    [self addSubview:pieceView];
    [pieceView playPenLayerAnimation];
    
}

- (void)connectLinesForCoordinates:(NSArray*)coordinates forPlayer:(NSInteger)playerIdx{
    
    CAShapeLayer *connectedLayer = playerIdx == 0 ? self.p1ConnectedLineLayer : self.p2ConnectedLineLayer;
    
    //get path from connected line layer. This is to ensure previous connected lines is not deleted
    UIBezierPath *thePath = [UIBezierPath bezierPathWithCGPath:connectedLayer.path];
    
    //coordinate is string format, so enumerate and
    [coordinates enumerateObjectsUsingBlock:^(NSString* coordinateString, NSUInteger idx, BOOL *stop) {
//        NSLog(@"%@", coordinateString);
        CGPoint pointInView = [self viewPointForCoordinate:CGPointFromString(coordinateString)];
        
        if (idx == 0) {//move to first point
            [thePath moveToPoint:pointInView];
        }
        
        if (idx < coordinates.count){//add line for how many point in it
            [thePath addLineToPoint:pointInView];
        }
        
        if (idx == coordinates.count -1){ //add line to first point again to close path
            CGPoint firstPoint = [self viewPointForCoordinate:CGPointFromString(coordinates[0])];
            [thePath addLineToPoint:firstPoint];
        }
    }];
    
    connectedLayer.path = thePath.CGPath;
    
    //still not found best way to animate
//    CGFloat animDuration  = coordinates.count * 0.2;
//    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    pathAnimation.duration = animDuration;
//    pathAnimation.fromValue = @(0.0f);
//    pathAnimation.toValue = @(1.0f);
//    [connectedLayer addAnimation:pathAnimation forKey:@"strokeEnd"];

}

#pragma mark Touch handling

//!Handle pan, tell delegate to handle touch coordinate when pan ended.
- (void)handlePan:(UIPanGestureRecognizer*)gesture
{
    CGPoint location = [gesture locationInView:self];
    CGPoint touchCoord = [self nearestBoardCoordinateForPoint:location];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
    }
    else if (gesture.state == UIGestureRecognizerStateChanged){
        [self.delegate boardView:self didEndTouchAtCoordinate:touchCoord]; //call delegate to add new piece
    }
    
}


//!Handle tap, if clicked once, tell delegate to handle coordinate
- (void)handleTap:(UITapGestureRecognizer*)gesture
{
    
    
    CGPoint location = [gesture locationInView:self];
    CGPoint touchCoord = [self nearestBoardCoordinateForPoint:location];
    [self.delegate boardView:self didEndTouchAtCoordinate:touchCoord]; //call delegate to add new piece

}


@end
