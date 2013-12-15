//
//  TTBoardPointAttribute.m
//  Konker
//
//  Created by Wan Ahmad Lutfi Wan Md Hatta on 14/12/13.
//  Copyright (c) 2013 wan. All rights reserved.
//

#import "TTCoordinateAttribute.h"

@implementation TTCoordinateAttribute

- (id)initWithCoordinate:(CGPoint)coordinate
{
    self = [super init];
    if (self) {
        _occupiedByPlayer = kTTPlayerNone;
        _coordinate = coordinate;
    }
    return self;
}

- (NSString*)coordinateString{
    return NSStringFromCGPoint(self.coordinate);
}


- (NSString*)description{
    return [NSString stringWithFormat:@"%@ : coordinate = %@", [super description], self.coordinateString];
}

@end
