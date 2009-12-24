#import "GameView.h"
#import "GameViewController.h"

@implementation GameView

@synthesize gameViewController;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		const int NUM_TILES = 3;
		
		const int testMap[10][10] = {
			{2, 2, 2, 1, 2, 2, 0, 0, 0, 0},
			{2, 2, 2, 1, 2, 2, 0, 0, 0, 0},
			{2, 2, 1, 2, 2, 2, 2, 0, 0, 0},
			{1, 1, 1, 2, 2, 2, 2, 2, 0, 0},
			{2, 1, 2, 2, 2, 2, 2, 2, 0, 2},
			{2, 1, 2, 2, 2, 2, 2, 0, 0, 2},
			{2, 2, 1, 2, 2, 2, 2, 0, 2, 2},
			{2, 2, 1, 1, 2, 2, 2, 2, 0, 2},
			{2, 2, 2, 1, 2, 2, 2, 2, 0, 2},
			{2, 2, 2, 2, 1, 2, 2, 2, 0, 2}
		};
		
		CGRect map_frame = [self frame];
		map_frame.size.height -= 20;
		map = [[UIView alloc] initWithFrame:map_frame];
		UIImage *tileImages = [UIImage imageNamed:@"hexes.png"];
		CGImageRef tileImageRefs[NUM_TILES];
		for (int i = 0; i < NUM_TILES; i++) {
			CGImageRef ir = CGImageCreateCopy([tileImages CGImage]);
			tileImageRefs[i] = CGImageCreateWithImageInRect(ir, CGRectMake(i*36, 0, 36, 32));
		}

		CALayer *tile_array[10][10];
		for (int i = 0; i < 10; i++) {
			for (int j = 0; j < 10; j++) {
				tile_array[i][j] = [CALayer layer];
				tile_array[i][j].position = CGPointMake(27.0f * i + 18, 32.0f * j + ((i % 2 == 1) ? 16.0f : 0.0f));
				tile_array[i][j].bounds = CGRectMake(0.0f, 0.0f, 36.0f, 32.0f);
				tile_array[i][j].contents = tileImageRefs[testMap[j][i]];

				[[map layer] addSublayer:tile_array[i][j]];
			}
		}
		
		[self addSubview:map];
	}
	
	return self;
}

- (void)dealloc {
	[map release];
	[super dealloc];
}

@end