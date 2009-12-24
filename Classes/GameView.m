#import "GameView.h"
#import "GameViewController.h"

@implementation GameView

@synthesize gameViewController;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		CGRect map_frame = [self frame];
		map_frame.size.height -= 20;
		map = [[UIView alloc] initWithFrame:map_frame];
		//map = [[UIView alloc] initWithImage:[UIImage imageNamed:@"player.png"]];
		//map.center = self.center;
		
		CALayer *tile = [CALayer layer];
		tile.position = CGPointMake(50.0f, 50.0f);
		tile.bounds = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
		UIImage *tile_contents_u = [UIImage imageNamed:@"player.png"];
		CGImageRef *tile_contents_i = tile_contents_u.CGImage;
		tile.contents = tile_contents_i;
		
		//UIImageView *tile = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player.png"]];
		//tile.center = map.center;
		[[map layer] addSublayer:tile];
		
		//[[map layer] addSublayer:tile];
		[self addSubview:map];
	}
	
	return self;
}

- (void)dealloc {
	[map release];
	[super dealloc];
}

@end