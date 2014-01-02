//
//  CALayer+Extension.m
//  Konker
//
//  Created by Wan Ahmad Lutfi Wan Md Hatta on 2/01/14.
//  Copyright (c) 2014 wan. All rights reserved.
//

#import "CALayer+Extension.h"

@implementation CALayer (Extension)

- (NSArray*)sublayersNamed:(NSString*)name{
    NSMutableArray *sublayers = [NSMutableArray array];
    for (CALayer *layer in self.sublayers) {
        if ([layer.name isEqualToString:name]) {
            [sublayers addObject:layer];
        }
    }
    
    if (sublayers.count > 0) {
        return sublayers;
    }
    return nil;
}

@end
