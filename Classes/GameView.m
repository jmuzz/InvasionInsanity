#import "GameView.h"
#import "GameViewController.h"
#import "Map.h"

@implementation GameView

@synthesize gameViewController, map;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		// Create map
		CGRect mapFrame = CGRectMake(0, 0, CGRectGetWidth([self frame]), CGRectGetHeight([self frame]) - 64);
		map = [[Map alloc] initWithFrame:mapFrame];

		// Create terrain info bar
		terrainInfoBar = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(mapFrame) + 32, CGRectGetWidth(mapFrame), 32)];
		selectedTerrainPicture = [CALayer layer];
		selectedTerrainPicture.anchorPoint = CGPointMake(0.0f, 0.0f);
		selectedTerrainPicture.position = CGPointMake(20.0f, 0.0f);
		selectedTerrainPicture.bounds = CGRectMake(0.0f, 0.0f, 36.0f, 32.0f);
		[[terrainInfoBar layer] addSublayer:selectedTerrainPicture];

		[self addSubview:terrainInfoBar];
		[self addSubview:map];
	}
	return self;
}

-(void)updateTerrainInfoWithHex:(CALayer *)hex {
	selectedTerrainPicture.contents = [hex contents];
}

- (void)dealloc {
	[map release];
	[terrainInfoBar release];
	[super dealloc];
}

@end