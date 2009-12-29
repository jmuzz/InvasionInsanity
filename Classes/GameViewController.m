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
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Touch Info" message:[NSString stringWithFormat:@"X:%i Y:%i", 1, 1] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
    }

	[gameView updateTerrainInfoWithX:0 Y:0];
};

/*- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.view removeFromSuperview];
	[self.delegate showGameOver:5];
}*/

@end