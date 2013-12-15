//
//  TTBoard.m
//  Konker
//
//  Created by Wan Ahmad Lutfi Wan Md Hatta on 14/12/13.
//  Copyright (c) 2013 wan. All rights reserved.
//

#import "TTBoard.h"
#import "TTCoordinateAttribute.h"


typedef enum
{
    kMoveUp = (1u << 0),
    kMoveRight = (1u << 1),
    kMoveDown = (1u << 2),
    kMoveLeft = (1u << 3),
    kMoveUpLeft = (1u << 4),
    kMoveUpRight = (1u << 5),
    kMoveDownRight = (1u << 6),
    kMoveDownLeft = (1u << 7),
}TTCoordinateMove;


@implementation TTBoard
{
    NSArray *boardPoints;
    CGPoint _initialCoordinate;
    BOOL _foundKonqerLoop;
    
    NSMutableOrderedSet *_currentEnumeratedConnectedCoordinates;
}

CGPoint CGPointAdd(CGPoint point1, CGPoint point2){
    return CGPointMake(point1.x+ point2.x, point1.y+point2.y);
}

- (id)initBoardWithRow:(NSInteger)rowCount column:(NSInteger)columnCount
{
    self = [super init];
    if (self) {
        _currentPlayerTurn = kTTPlayer1;
        _boardSize.width    = columnCount;
        _boardSize.height   = rowCount;
        
        NSMutableArray *tempBoardPoints = [NSMutableArray arrayWithCapacity:columnCount];
        
        for (NSUInteger i=0; i<columnCount; i++) {
            NSMutableArray *aColumnArray = [NSMutableArray arrayWithCapacity:rowCount]; //a column has capacity with row count
        
            for (NSUInteger j=0; j<rowCount; j++) {
                TTCoordinateAttribute *pointAttr = [[TTCoordinateAttribute alloc] initWithCoordinate:CGPointMake(i, j)];
                [aColumnArray addObject:pointAttr]; //put each point attributes into column
            }
            [tempBoardPoints addObject:aColumnArray];//put column in boardPoints
            boardPoints = tempBoardPoints.copy;
        }
    }
    return self;
}

- (void)handleTouchAtCoordinate:(CGPoint)coordinate{
    if ([self eligibleMoveAtCoordinate:coordinate]) {
        [self handlePlayer:_currentPlayerTurn moveAtCoordinate:coordinate];
        [self.delegate player:_currentPlayerTurn didMoveAtCoordinate:coordinate];
        [self endCurrentPlayerTurn]; //end current turn and swith to next player
    }
}

- (void)handlePlayer:(TTPlayer)player moveAtCoordinate:(CGPoint)coordinate{
    TTCoordinateAttribute *pointAttr = boardPoints[(NSInteger)coordinate.x][(NSInteger)coordinate.y]; //get point attribute for given coordinate
    pointAttr.occupiedByPlayer = player;
    
    //Before find connected konqer, need setup _initialCoordinate and _foundKonqerLoop
    _initialCoordinate = coordinate;
    _foundKonqerLoop = NO;
    
    _currentEnumeratedConnectedCoordinates = [NSMutableOrderedSet orderedSet];
     [self enumerateConnectedCoordinateFrom:coordinate moveFrom:-1 forPlayer:player];
    
    //handle when konqerer occured, min konqere is 4 point
    if (_foundKonqerLoop ) {
        
        //need verify if the loop is permissible in the game
        NSArray *verifiedConnectedCoordinates = [self verifyConnectedCoordinateAttributes:_currentEnumeratedConnectedCoordinates.array forPlayer:player];
        
        for (TTCoordinateAttribute *coordAttr in verifiedConnectedCoordinates) {
            coordAttr.konqerer = YES; //set as konqurer as it conquer opponent pieces
        }
        
        //CGPoint cannot be put into array, so we use string instead
        NSArray *coordinateStrings = [verifiedConnectedCoordinates valueForKey:@"coordinateString"];
        
        //call delegate to tell pieces has become konqerer
        [self.delegate player:player piecesThatBecomeKonqerer:coordinateStrings];
    }
    
//    NSLog(@"%@", _currentEnumeratedConnectedCoordinates);
}

- (void)endCurrentPlayerTurn
{
    if (_currentPlayerTurn == kTTPlayer1) {
        _currentPlayerTurn = kTTPlayer2;
    }
    else if (_currentPlayerTurn == kTTPlayer2){
        _currentPlayerTurn = kTTPlayer1;
    }
}



-(void)enumerateConnectedCoordinateFrom:(CGPoint)coordinate moveFrom:(TTCoordinateMove)moveFrom forPlayer:(TTPlayer)player{
    //total number of move is 8. Enumerate each of it to check connected coordinates.
    for (NSUInteger i=0; i<8; i++) {
        
        TTCoordinateMove currentMove = (1u << i); //get current move
        
        //if current move is going to previous coordinate, continue
        if (moveFrom == [self reverseMove:currentMove]) {
            continue;
        }
        
        //break if found konqer loop
        if (_foundKonqerLoop) {
            break;
        }
        
        TTCoordinateAttribute *coordAttr = [self pieceForPlayer:player forCoordinate:coordinate withMove:currentMove];
        if (coordAttr && coordAttr && ![coordAttr isCaptured]) {//can be added if only not captured
            CGPoint moveCoordinate = [self coordinate:coordinate withMove:currentMove];

            //if if next move is equal to initial coordinate, means that konquer occured, break the loop, no need search anymore
            if (CGPointEqualToPoint(moveCoordinate, _initialCoordinate)) {
                [_currentEnumeratedConnectedCoordinates addObject:coordAttr];
                _foundKonqerLoop = YES;
                break;
            }

            //can only add and enumerate next if the piece is of current player and the attribute must not already added
            if (coordAttr.occupiedByPlayer == player && ![_currentEnumeratedConnectedCoordinates containsObject:coordAttr]) {
                [_currentEnumeratedConnectedCoordinates addObject:coordAttr];
                [self enumerateConnectedCoordinateFrom:moveCoordinate moveFrom:currentMove forPlayer:player];
            }
            else continue; //continue if coordAttr is not move made by given player
        }
        
    }
}

//!Check if the coordinates loop is permissible. if not return nil. If YES return new coordinate attributes
- (NSArray*)verifyConnectedCoordinateAttributes:(NSArray*)coordinateAttributes forPlayer:(TTPlayer)player{
    if (coordinateAttributes.count < 4) {
        return nil;
    }
    
    
    //Get leftmost and rightmost coordinate attributes. This is to get coordinates lie in the bound of given coordinate attributes
    NSArray *leftMostAttributes;
    NSArray *rightMostAttributes;
    [self getFromCoordinateAttributes:coordinateAttributes leftMostAttributes:&leftMostAttributes rightMostAttributes:&rightMostAttributes];

    if (leftMostAttributes.count == rightMostAttributes.count) {
        //number of piece count in bound of given coordinate attributes
        NSInteger currentPlayerPieceCount   = 0;
        NSInteger otherPlayerPieceCount     = 0;
        NSInteger emptyPieceCount           = 0;
        
        for (NSUInteger i=0; i<leftMostAttributes.count; i++) {
            TTCoordinateAttribute *left = leftMostAttributes[i];
            TTCoordinateAttribute *rigth = rightMostAttributes[i];
            
            NSInteger currentCol = left.coordinate.x;
            while (currentCol < rigth.coordinate.x) {
                TTCoordinateAttribute *attrBetween = boardPoints[currentCol][(NSInteger)left.coordinate.y];
                
                if (attrBetween.occupiedByPlayer ==kTTPlayerNone) {
                    emptyPieceCount++;
                }
                else if (attrBetween.occupiedByPlayer == player) {
                    currentPlayerPieceCount++;
                }
                else {
                    attrBetween.captured = YES;
                    otherPlayerPieceCount++;
                }
                
                currentCol++;
            }
        }
    }
    
    return coordinateAttributes;
}

//!Get left most coordinates
- (void)getFromCoordinateAttributes:(NSArray*)coordinates leftMostAttributes:(NSArray**)leftMostAttributes rightMostAttributes:(NSArray**)rightMostAttributes
{
    __block TTCoordinateAttribute *topAttr;
    __block TTCoordinateAttribute *bottomAttr;
    
    __block NSInteger topRow = INFINITY;
    __block NSInteger bottomRow = -INFINITY;
    
    [coordinates enumerateObjectsUsingBlock:^(TTCoordinateAttribute *attr, NSUInteger idx, BOOL *stop) {
        if (attr.coordinate.y >bottomRow) {
            bottomRow = attr.coordinate.y;
            bottomAttr = attr;
        }
        if (attr.coordinate.y <topRow) {
            topRow = attr.coordinate.y;
            topAttr = attr;
        }
    }];
    
    NSInteger rowToEnumerate = bottomRow - topRow -1; //minus 1 because need only calculate in between top and bottom row
    NSMutableArray *leftCoordinates = [NSMutableArray arrayWithCapacity:rowToEnumerate];
    NSMutableArray *rightCoordinates = [NSMutableArray arrayWithCapacity:rowToEnumerate];
    
    for (NSUInteger row=topRow+1; row<bottomRow; row++) {
        __block TTCoordinateAttribute * leftMostAttributeForCurrentRow;
        __block TTCoordinateAttribute * rightMostAttributeForCurrentRow;
        
        __block NSInteger leftColumn = INFINITY;
        __block NSInteger rightColumn = -INFINITY;
        
        [coordinates enumerateObjectsUsingBlock:^(TTCoordinateAttribute *attr, NSUInteger idx, BOOL *stop) {
            if (attr.coordinate.y == row) {
                if (attr.coordinate.x > rightColumn) {
                    rightColumn = attr.coordinate.x;
                    rightMostAttributeForCurrentRow = attr;
                }
                if (attr.coordinate.x < leftColumn) {
                    leftColumn = attr.coordinate.x;
                    leftMostAttributeForCurrentRow = attr;
                }
            }
        }];
        
        //add leftmost and rightmost attribute for current row into array
        [leftCoordinates addObject:leftMostAttributeForCurrentRow];
        [rightCoordinates addObject:rightMostAttributeForCurrentRow];
        
    }
    *leftMostAttributes = leftCoordinates;
    *rightMostAttributes = rightCoordinates;
}

//- (BOOL)canConnectBetweenCoordinate:(CGPoint)firstCoord toCoordinate:(CGPoint)secondCoord{
//    
//}

#pragma mark Check for move

//!Return reverse move of given move
- (TTCoordinateMove)reverseMove:(TTCoordinateMove)move{
    
    TTCoordinateMove reverseMove;
    switch (move) {
        case kMoveUp:
            reverseMove = kMoveDown;
            break;
        case kMoveRight:
            reverseMove = kMoveLeft;
            break;
        case kMoveDown:
            reverseMove = kMoveUp;
            break;
        case kMoveLeft:
            reverseMove = kMoveRight;
            break;
        case kMoveUpLeft:
            reverseMove = kMoveDownRight;
            break;
        case kMoveUpRight:
            reverseMove = kMoveDownLeft;
            break;
        case kMoveDownRight:
            reverseMove = kMoveUpLeft;
            break;
        case kMoveDownLeft:
            reverseMove = kMoveUpRight;
            break;
        default:
            reverseMove = -1;
            break;
    }
    return reverseMove;
}

- (TTCoordinateAttribute*)pieceForPlayer:(TTPlayer)player forCoordinate:(CGPoint)coordinate withMove:(TTCoordinateMove)move{
    
    CGPoint destinationCoord = [self coordinate:coordinate withMove:move];
    TTCoordinateAttribute *pointAttr = boardPoints[(NSInteger)destinationCoord.x][(NSInteger)destinationCoord.y];
    if (pointAttr.occupiedByPlayer == player) {
        return pointAttr;
    }
    return nil;
}


/**
 *  Get new coordinate with given coordinate and move
 *
 *  @param coordinate coordinate
 *  @param move       move type
 *
 *  @return return new coordinate
 */
- (CGPoint)coordinate:(CGPoint)coordinate withMove:(TTCoordinateMove)move{
    CGPoint newCoordinate;
    switch (move) {
        case kMoveUp:
            newCoordinate = CGPointAdd(coordinate, CGPointMake(0, -1));
            break;
        case kMoveRight:
            newCoordinate = CGPointAdd(coordinate, CGPointMake(1, 0));
            break;
        case kMoveDown:
            newCoordinate = CGPointAdd(coordinate, CGPointMake(0, 1));
            break;
        case kMoveLeft:
            newCoordinate = CGPointAdd(coordinate, CGPointMake(-1, 0));
            break;
        case kMoveUpLeft:
            newCoordinate = CGPointAdd(coordinate, CGPointMake(-1, -1));
            break;
        case kMoveUpRight:
            newCoordinate = CGPointAdd(coordinate, CGPointMake(1, -1));
            break;
        case kMoveDownRight:
            newCoordinate = CGPointAdd(coordinate, CGPointMake(1, 1));
            break;
        case kMoveDownLeft:
            newCoordinate = CGPointAdd(coordinate, CGPointMake(-1, 1));
            break;
        default:
            break;
    }
    return newCoordinate;
}

//for konqer game, both player can move at any place except where has been placed
- (BOOL)eligibleMoveAtCoordinate:(CGPoint)coordinate{
    if (![self isWithinBoardCoordinate:coordinate]) { //return NO if coordinate not within board
        return NO;
    };
    
    //Get point attribute for given coordinate, if still no move from either player, return YES
    TTCoordinateAttribute *pointAttr = boardPoints[(NSInteger)coordinate.x][(NSInteger)coordinate.y];
    if (pointAttr.occupiedByPlayer == kTTPlayerNone) {
        return YES;
    }
    else return NO;
}

- (BOOL)isWithinBoardCoordinate:(CGPoint)p
{
    if (p.x < _boardSize.width && p.y <= _boardSize.height) {
        return YES;
    }
    return NO;
}
@end
