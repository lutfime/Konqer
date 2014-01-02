//
//  TTBoardPointAttribute.h
//  Konker
//
//  Created by Wan Ahmad Lutfi Wan Md Hatta on 14/12/13.
//  Copyright (c) 2013 wan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTBoard.h"

@interface TTCoordinateAttribute : NSObject

@property (nonatomic, readonly) CGPoint coordinate;
@property (nonatomic, readonly) NSString *coordinateString;

//!Used for sorting, used for distance. tempVal because can be used for any
@property (nonatomic, assign) CGFloat tempVal;

@property (nonatomic, assign) TTPlayer occupiedByPlayer;
//!this coordinate is a konqere if it conquer other pieces
@property (nonatomic, assign, getter = isKonqerer) BOOL konqerer;

@property (nonatomic, assign, getter = isCaptured) BOOL captured;

- (id)initWithCoordinate:(CGPoint)coordinate;

@end
