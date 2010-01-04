#import "GameViewController.h"
#import "GameView.h"
#import "Map.h"
#import "GamePiece.h"

@implementation GameViewController

@synthesize gameView, delegate;

- (void) loadView {
	self.wantsFullScreenLayout = YES;

	GameView *view = [[GameView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	view.gameViewController = self;
	self.view = view;
	self.gameView = view;
	gameState = waitingState;
	[view release];
}

- (void)cancelMove {
	gameState = unitSelectedState;
	[selectedPiece setCoordsToX:oldPieceX y:oldPieceY];
	[gameView updateActionButtonBoxWithState:gameState];
}

- (void)finishMove {
	gameState = waitingState;
	selectedPiece.moved = true;
	[gameView updateActionButtonBoxWithState:gameState];
}

- (void)deselectPiece {
	selectedPiece = nil;
	gameState = waitingState;
	[gameView updateActionButtonBoxWithState:gameState];
	[gameView updatePieceInfoWithPiece:nil];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) {
		Map *map = gameView.map;

		CGPoint tloc = [touch locationInView:map];
		CALayer *hex = [map hexFromPoint:tloc];
		if (hex) {
			GamePiece *piece = [map pieceFromPoint:tloc];
			switch (gameState) {
				case waitingState:
					if (piece && piece.moved == false) {
						gameState = unitSelectedState;
						selectedPiece = piece;
						oldPieceX = piece.x;
						oldPieceY = piece.y;
					}

					[gameView updateTerrainInfoWithHex:hex];
					[gameView updatePieceInfoWithPiece:piece];
					break;
				
				case unitSelectedState:
					if (!piece) {
						[selectedPiece setCoordsToX:[map hexXFromPoint:tloc] y:[map hexYFromPoint:tloc]];
						gameState = verifyMoveState;
					}
					break;
					
				case verifyMoveState:
					if (!piece) {
						[selectedPiece setCoordsToX:[map hexXFromPoint:tloc] y:[map hexYFromPoint:tloc]];
						if (selectedPiece.x == oldPieceX && selectedPiece.y == oldPieceY) {
							gameState = unitSelectedState;
						}
					}
					break;
			}
			[gameView updateActionButtonBoxWithState:gameState];
		}
    }
}

@end