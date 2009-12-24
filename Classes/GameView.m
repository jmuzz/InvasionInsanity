#import "GameView.h"
#import "GameViewController.h"

@implementation GameView

@synthesize gameViewController;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		player = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player.png"]];
		player.center = self.center;
		[self addSubview:player];
	}
	
	return self;
}

- (void)dealloc {
	[player release];
	[super dealloc];
}

@end