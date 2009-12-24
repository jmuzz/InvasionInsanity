#import "GameOverViewController.h"

@implementation GameOverViewController

@synthesize delegate;

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

- (IBAction) mainMenu: (id) sender {
	[self.view removeFromSuperview];
	[self.delegate showMenu];
}

@end