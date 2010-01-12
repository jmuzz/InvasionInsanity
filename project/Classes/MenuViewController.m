#import "MenuViewController.h"

@implementation MenuViewController

@synthesize score, delegate;

- (IBAction) play: (id) sender {
	[self.view removeFromSuperview];
	[self.delegate startGame];
}

- (IBAction) help: (id) sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Helpings" message:@"Consider yourself helped" delegate:nil cancelButtonTitle:@"I guess" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)viewDidUnload {
	self.score = nil;
}

- (void)dealloc {
    [super dealloc];
}

@end