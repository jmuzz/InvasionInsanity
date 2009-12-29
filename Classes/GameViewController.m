#import "GameViewController.h"
#import "GameView.h"

@implementation GameViewController

@synthesize gameView, delegate;

- (void) loadView {
	self.wantsFullScreenLayout = YES;
	
	GameView *view = [[GameView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	view.gameViewController = self;
	self.view = view;
	self.gameView = view;
	[view release];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) {
		// Approximate which hex was tapped by using a bounding box
		CGPoint tloc = [touch locationInView:gameView.map];
		
		int tile_x = tloc.x / 27;
		if (tile_x >= gameView.hexes_wide) tile_x = gameView.hexes_wide - 1;
		int tile_y = (tloc.y - ((tile_x % 2 == 1) ? 16 : 0)) / 32;
		if (tile_y >= gameView.hexes_high) tile_y = gameView.hexes_high - 1;
		
		[gameView updateTerrainInfoWithX:tile_x Y:tile_y];
    }
};

@end