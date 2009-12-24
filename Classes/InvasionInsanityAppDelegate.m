#import "InvasionInsanityAppDelegate.h"
#import "MenuViewController.h"
#import "GameViewController.h"

void MyUncaughtExceptionHandler(NSException *exception) {
	NSArray *callStackArray = [exception callStackReturnAddresses];
	int frameCount = [callStackArray count];
	void *backtraceFrames[frameCount];
	
	for (int i=0; i<frameCount; i++) {
		backtraceFrames[i] = (void *)[[callStackArray objectAtIndex:i] unsignedIntegerValue];
	}
	
	// report the exception
}

@implementation InvasionInsanityAppDelegate

@synthesize window, gameViewController, menuViewController, gameOverViewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	NSSetUncaughtExceptionHandler(&MyUncaughtExceptionHandler);
	
	// Set up menu view controller
	MenuViewController *mViewController = [[MenuViewController alloc] init];
	mViewController.delegate = self;
	self.menuViewController = mViewController;
	[mViewController release];
	
	// Set up the game view controller
	GameViewController *gViewController = [[GameViewController alloc] init];
	gViewController.delegate = self;
	self.gameViewController = gViewController;
	[gViewController release];
	
	// Set up the game over view controller
	GameOverViewController *goViewController = [[GameOverViewController alloc] init];
	goViewController.delegate = self;
	self.gameOverViewController = goViewController;
	[goViewController release];
	
	// Add the menu to the window
	//menuViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	//[window addSubview:[menuViewController view]];
	[self showMenu];
}

- (void)showGameOver:(int)score {
	gameOverViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[gameOverViewController view]];
}

- (void)startGame {
	gameViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[gameViewController view]];
}

- (void)showMenu {
	menuViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[menuViewController view]];
}

- (void)dealloc {
    [window release];
	[menuViewController release];
	[gameViewController release];
	[gameOverViewController release];
    [super dealloc];
}

@end