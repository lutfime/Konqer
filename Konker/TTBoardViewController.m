//
//  TTBoardViewController.m
//  Konker
//
//  Created by Wan Ahmad Lutfi Wan Md Hatta on 11/12/13.
//  Copyright (c) 2013 wan. All rights reserved.
//

#import "TTBoardViewController.h"
#import "TTBoard.h"

@interface TTBoardViewController ()
@property (strong, nonatomic) IBOutlet TTBoardView *boardView;
@property (nonatomic, strong) TTBoard *board;

@end

@implementation TTBoardViewController{
    NSArray *_lastTestCoordinates;
    NSArray *_lastTestCoordinates2;
    BOOL debug;
}

#pragma mark Life

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.board = [[TTBoard alloc] initBoardWithRow:self.boardView.numberOfRow column:self.boardView.numberOfColumn];
    
    self.board.delegate = self;
    self.boardView.delegate = self;
    
    debug = NO;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Board delegate

- (void)player:(TTPlayer)player didMoveAtCoordinate:(CGPoint)coordinate{
    
    NSInteger playerIdx = player == kTTPlayer1 ? 0 : 1;
    [self.boardView moveAtCoordinate:coordinate forPlayerIndex:playerIdx];
}

- (void)player:(TTPlayer)player piecesThatBecomeKonqerer:(NSArray *)coordinates
{
    NSInteger playerIdx = player == kTTPlayer1 ? 0 : 1;
    [self.boardView connectLinesForCoordinates:coordinates forPlayer:playerIdx];
}

- (void)player:(TTPlayer)player testPieces:(NSArray *)coordinates{
    if (debug) {
        [self.boardView showTestCoordinates:coordinates duration:1];
    }
    
    _lastTestCoordinates = coordinates;
}

- (void)player:(TTPlayer)player testPieces2:(NSArray *)coordinates{
//    [self.boardView showTestCoordinates:coordinates duration:1];
    _lastTestCoordinates2 = coordinates;
}

#pragma mark - Board view delegate

- (void)boardView:(TTBoardView *)boardView didEndTouchAtCoordinate:(CGPoint)coord
{
    [self.board handleTouchAtCoordinate:coord];
}

#pragma mark -Testing

- (IBAction)checkLastCoordinates:(id)sender {
    [self.boardView animateTestCoordinates:_lastTestCoordinates duration:5];
}

- (IBAction)checkLastCoordinates2:(id)sender {
    [self.boardView animateTestCoordinates:_lastTestCoordinates2 duration:7];

}




@end
