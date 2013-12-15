//
//  TTPieceView.h
//  Konker
//
//  Created by Wan Ahmad Lutfi Wan Md Hatta on 14/12/13.
//  Copyright (c) 2013 wan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTPieceView : UIView

- (void)playPenLayerAnimation;


//! Init with frame and color, the color is used to color the piece move
- (id)initWithFrame:(CGRect)frame color:(UIColor*)color;

@end
