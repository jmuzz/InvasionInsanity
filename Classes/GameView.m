#import "GameView.h"
#import "GameViewController.h"

@implementation GameView

@synthesize gameViewController, map, hex_width, hex_height;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		int testMap[10][10] = {
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
		
		hex_width = MAP_WIDTH;
		hex_height = MAP_HEIGHT;
		
		// Load tile images
		UIImage *tileImages = [UIImage imageNamed:@"hexes.png"];
		for (int i = 0; i < NUM_TILE_TYPES; i++) {
			CGImageRef ir = CGImageCreateCopy([tileImages CGImage]);
			tileImageRefs[i] = CGImageCreateWithImageInRect(ir, CGRectMake(i*36, 0, 36, 32));
		}
		
		// Create map
		CGRect mapFrame = [self frame];
		mapFrame.size.height -= 64;
		map = [[UIView alloc] initWithFrame:mapFrame];
		
		// Create terrain info bar
		terrainInfoBar = [[UIView alloc] initWithFrame:CGRectMake(0, mapFrame.size.height + 32, mapFrame.size.width, 32)];
		selectedTerrainPicture = [CALayer layer];
		selectedTerrainPicture.position = CGPointMake(40.0f, 0.0f);
		selectedTerrainPicture.bounds = CGRectMake(0.0f, 0.0f, 36.0f, 32.0f);
		[[terrainInfoBar layer] addSublayer:selectedTerrainPicture];

		// Load terrain data and create tile layers and add them to map
		for (int i = 0; i < MAP_WIDTH; i++) {
			for (int j = 0; j < MAP_HEIGHT; j++) {
				gameTerrain[i][j] = testMap[j][i];
				tileArray[i][j] = [CALayer layer];
				tileArray[i][j].anchorPoint = CGPointMake(0.0f, 0.0f);
				tileArray[i][j].position = CGPointMake(27.0f * i, 32.0f * j + ((i % 2 == 1) ? 16.0f : 0.0f));
				tileArray[i][j].bounds = CGRectMake(0.0f, 0.0f, 36.0f, 32.0f);
				tileArray[i][j].contents = tileImageRefs[gameTerrain[i][j]];

				[[map layer] addSublayer:tileArray[i][j]];
			}
		}
		
		[self addSubview:terrainInfoBar];
		[self addSubview:map];
	}
	
	return self;
}

-(void)updateTerrainInfoWithX:(int)x Y:(int)y {
	selectedTerrainPicture.contents = tileImageRefs[gameTerrain[x][y]];
}

- (void)dealloc {
	[map release];
	[super dealloc];
}

@end