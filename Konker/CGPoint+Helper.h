//
//  CGPoint+Helper.h
//  Konker
//
//  Created by Wan Ahmad Lutfi Wan Md Hatta on 14/12/13.
//  Copyright (c) 2013 wan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _RectAttribute
{
    kRectUndefined = 0,
    kRectMinX = 1,
    kRectMidX = 1 << 1,
    kRectMaxX = 1 << 2,
    kRectMinY = 1 << 3,
    kRectMidY = 1 << 4,
    kRectMaxY = 1 << 5,
    
    kRectLowerLeft = 9,
    kRectLowerRight = 12,
    kRectUpperRight = 36,
    kRectUpperLeft = 33,
    kRectMiddleLeft = 17,
    kRectMiddleDown = 10,
    kRectMiddleUp = 34,
    kRectMiddleRight = 20,
    kRectMiddle = 18 //tembak
    
}RectAttribute;

CGPoint WLPointForRectAndAttributeWithFactor(CGRect aRect, RectAttribute attr, CGPoint factor);
