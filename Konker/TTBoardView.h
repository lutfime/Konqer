//
//  TTBoardView.h
//  Konker
//
//  Created by Wan Ahmad Lutfi Wan Md Hatta on 11/12/13.
//  Copyright (c) 2013 wan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTBoardViewDelegate;

@interface TTBoardView : UIView

@property (nonatomic, assign) id<TTBoardViewDelegate>delegate;
@property (nonatomic, strong) UIColor *player1Color;
@property (nonatomic, strong) UIColor *player2Color;

@property (nonatomic, assign) NSInteger numberOfRow;
@property (nonatomic, assign) NSInteger numberOfColumn;

//!Tell view to place a piece at given coordinate for given  player index
- (void)moveAtCoordinate:(CGPoint)coordinate forPlayerIndex:(NSInteger)playerIndex;

//!Connect lines from given coordinate for player. The object in coordinates is in string format
- (void)connectLinesForCoordinates:(NSArray*)coordinates forPlayer:(NSInteger)playerIdx;

//!testing
- (void)showTestCoordinates:(NSArray*)coordinates duration:(NSTimeInterval)duration;
- (void)animateTestCoordinates:(NSArray*)coordinates duration:(NSTimeInterval)duration;
@end

@protocol TTBoardViewDelegate <NSObject>
- (void)boardView:(TTBoardView*)boardView didEndTouchAtCoordinate:(CGPoint)coord;

@end