#import "GameViewController.h"
#import "GameView.h"
#import "Map.h"
#import "GamePiece.h"

@implementation GameViewController

@synthesize gameView, delegate, currentPlayerTurn, gameState, selectedPiece;

- (void) loadView {
	self.wantsFullScreenLayout = YES;

	GameView *view = [[GameView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	view.gameViewController = self;
	self.view = view;
	self.gameView = view;
	gameState = waitingState;
	currentPlayerTurn = 0;
	view.map.gameViewController = self;
	[self refreshView];
	[view release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		switch (currentPlayerTurn) {
			case (0):
				currentPlayerTurn = 1;
				break;
				
			case (1):
				currentPlayerTurn = 0;
				break;
		}
		
		[gameView.map startNewTurn];
		[self refreshView];
	}
}

- (void)endTurn {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"End your turn" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[alert show];
	[alert release];
}

- (void)cancelMove {
	gameState = unitSelectedState;
	[selectedPiece setCoordsToX:oldPieceX y:oldPieceY];
	[self refreshView];
}

- (void)finishMove {
	gameState = waitingState;
	selectedPiece.moved = true;
	[self refreshView];
}

- (void)deselectPiece {
	selectedPiece = nil;
	gameState = waitingState;
	[self refreshView];
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
					if (piece && piece.moved == false && piece.player == currentPlayerTurn) {
						gameState = unitSelectedState;
						selectedPiece = piece;
						oldPieceX = piece.x;
						oldPieceY = piece.y;
					}
					
					if (piece.player != currentPlayerTurn) {
						selectedPiece = piece;
					}
					
					if (!piece) {
						selectedPiece = nil;
					}
					
					selectedHex = hex;
					break;

				case unitSelectedState:
					if (!piece) {
						[selectedPiece setCoordsToX:[map hexXFromPoint:tloc] y:[map hexYFromPoint:tloc]];
						gameState = verifyMoveState;
						selectedHex = hex;
					}
					break;

				case verifyMoveState:
					if (!piece) {
						[selectedPiece setCoordsToX:[map hexXFromPoint:tloc] y:[map hexYFromPoint:tloc]];
						if (selectedPiece.x == oldPieceX && selectedPiece.y == oldPieceY) {
							gameState = unitSelectedState;
						}
						selectedHex = hex;
					}
					break;
			}
			[self refreshView];
		}
    }
}

- (void)refreshView {
	[gameView.map updateShades];
	[gameView updateActionButtonBoxWithState:gameState];
	[gameView updatePieceInfoWithPiece:selectedPiece];
	[gameView updateTerrainInfoWithHex:selectedHex];
}

@end