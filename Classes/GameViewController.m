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
	[self.view removeFromSuperview];
	[self.delegate showGameOver:5];
}

@end