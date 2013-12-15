//
//  CGPoint+Helper.m
//  Konker
//
//  Created by Wan Ahmad Lutfi Wan Md Hatta on 14/12/13.
//  Copyright (c) 2013 wan. All rights reserved.
//

#import "CGPoint+Helper.h"

CGPoint WLPointForRectWithAttribute(CGRect aRect, RectAttribute attr)
{
    switch (attr) {
        case kRectLowerLeft:
            attr = kRectUpperLeft;
            break;
        case kRectLowerRight:
            attr = kRectUpperRight;
            break;
        case kRectUpperLeft:
            attr = kRectLowerLeft;
            break;
        case kRectUpperRight:
            attr = kRectLowerRight;
            break;
        case kRectMiddleDown:
            attr = kRectMiddleUp;
            break;
        case kRectMiddleUp:
            attr = kRectMiddleDown;
            break;
            
        default:
            break;
    }
    
    CGRect frame = aRect;
    CGPoint point;
    switch (attr) {
        case kRectMinX|kRectMinY:
            point = CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame));
            break;
        case kRectMinX|kRectMidY:
            point = CGPointMake(CGRectGetMinX(frame), CGRectGetMidY(frame));
            break;
        case kRectMinX|kRectMaxY:
            point = CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame));
            break;
        case kRectMidX|kRectMinY:
            point = CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame));
            break;
        case kRectMidX|kRectMidY:
            point = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
            break;
        case kRectMidX|kRectMaxY:
            point = CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame));
            break;
        case kRectMaxX|kRectMinY:
            point = CGPointMake(CGRectGetMaxX(frame), CGRectGetMinY(frame));
            break;
        case kRectMaxX|kRectMidY:
            point = CGPointMake(CGRectGetMaxX(frame), CGRectGetMidY(frame));
            break;
        case kRectMaxX|kRectMaxY:
            point = CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame));
            
            break;
        default:
            NSLog(@"pointWithRectAttribute: , please provide two attr , X and Y");
            break;
    }
    return point;
}

CGPoint WLPointForRectAndAttributeWithFactor(CGRect aRect, RectAttribute attr, CGPoint factor)
{
    CGFloat width = CGRectGetWidth(aRect);
    CGFloat height = CGRectGetHeight(aRect);
    
    CGPoint edgePoint = WLPointForRectWithAttribute(aRect, attr);
    
    CGFloat dx = factor.x * width;
    CGFloat dy = factor.y * height;
    
    //    CGPoint point = aRect.origin;
    
    switch (attr) {
        case kRectLowerLeft:
        {
            dy = -dy; //if ios
            edgePoint.x += dx;
            edgePoint.y += dy;
        }
            break;
        case kRectUpperLeft:
        {
            edgePoint.x += dx;
            edgePoint.y += dy;
        }
            break;
        case kRectUpperRight:
        {
            dx = -dx;
            edgePoint.x += dx;
            edgePoint.y += dy;
        }
            break;
        case kRectLowerRight:
        {
            dx = -dx;
            dy = -dy; //if ios
            edgePoint.x += dx;
            edgePoint.y += dy;
        }
            break;
        default:
            break;
    }
    return edgePoint;
}