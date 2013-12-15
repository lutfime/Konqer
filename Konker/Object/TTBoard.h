//
//  TTBoard.h
//  Konker
//
//  Created by Wan Ahmad Lutfi Wan Md Hatta on 14/12/13.
//  Copyright (c) 2013 wan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    kTTPlayerNone = 0,
    kTTPlayer1,
    kTTPlayer2
}TTPlayer;

@protocol TTBoardDelegate <NSObject>

- (void)player:(TTPlayer)player didMoveAtCoordinate:(CGPoint)coordinate;

/**
 *  Call delegate when pieces have conquered opponent pieces
 *
 *  @param player      player that konquer
 *  @param coordinates coordinates of the konqerer pieces
 */
- (void)player:(TTPlayer)player piecesThatBecomeKonqerer:(NSArray*)coordinates;

@end

@interface TTBoard : NSObject

@property (nonatomic, assign) id<TTBoardDelegate>delegate;
@property (nonatomic, readonly) TTPlayer currentPlayerTurn;
@property (nonatomic, assign) CGSize boardSize;


- (id)initBoardWithRow:(NSInteger)rowCount column:(NSInteger)columnCount;
- (void)handleTouchAtCoordinate:(CGPoint)coordinate;

@end
