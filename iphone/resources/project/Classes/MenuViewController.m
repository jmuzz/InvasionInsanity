#import "MenuViewController.h"

@implementation MenuViewController

@synthesize score, delegate;

- (IBAction) map1: (id) sender {
	[self.view removeFromSuperview];
	[self.delegate startGame:1];
}

- (IBAction) map2: (id) sender {
	[self.view removeFromSuperview];
	[self.delegate startGame:2];
}

- (IBAction) map3: (id) sender {
	[self.view removeFromSuperview];
	[self.delegate startGame:3];
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