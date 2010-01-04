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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) {
		Map *map = gameView.map;

		CGPoint tloc = [touch locationInView:map];
		CALayer *hex = [map hexFromPoint:tloc];
		GamePiece *piece = [map pieceFromPoint:tloc];

		[gameView updateTerrainInfoWithHex:hex];
		[gameView updatePieceInfoWithPiece:piece];
    }
};

@end