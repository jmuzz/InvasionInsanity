#import "Map.h"
#import "GamePiece.h"

@implementation Map

@synthesize hexes_wide, hexes_high;

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

		hexes_wide = MAP_WIDTH;
		hexes_high = MAP_HEIGHT;

		// Load tile images
		UIImage *tileImages = [UIImage imageNamed:@"hexes.png"];
		CGImageRef ir = CGImageCreateCopy([tileImages CGImage]);
		for (int i = 0; i < NUM_TILE_TYPES; i++) {
			tileImageRefs[i] = CGImageCreateWithImageInRect(ir, CGRectMake(i*36, 0, 36, 32));
		}

		// Load terrain data and create tile layers and add them to map
		for (int i = 0; i < MAP_WIDTH; i++) {
			for (int j = 0; j < MAP_HEIGHT; j++) {
				tileArray[i][j] = [CALayer layer];
				tileArray[i][j].anchorPoint = CGPointMake(0.0f, 0.0f);
				tileArray[i][j].position = CGPointMake(27.0f * i, 32.0f * j + ((i % 2 == 1) ? 16.0f : 0.0f));
				tileArray[i][j].bounds = CGRectMake(0.0f, 0.0f, 36.0f, 32.0f);
				int terrainType = testMap[j][i];
				[tileArray[i][j] setValue:[NSNumber numberWithInteger:terrainType] forKey:@"terrainType"];
				tileArray[i][j].contents = tileImageRefs[terrainType];

				[[self layer] addSublayer:tileArray[i][j]];
			}
		}
    }
    return self;
}

- (bool)addGamePiece:(GamePiece *)piece atX:(int)x y:(int)y {
	CGPoint location = [self locationOfHexAtX:x y:y];
	piece.anchorPoint = CGPointMake(0.0f, 0.0f);
	piece.position = location;
	piece.map = self;
	return true;
}

- (CGPoint)locationOfHexAtX:(int)x y:(int)y {
	return tileArray[x][y].position;
}

- (CALayer *)hexFromPoint:(CGPoint)point {
	// Approximate which hex was tapped by using a bounding box
	int tile_x = point.x / 27;
	if (tile_x >= hexes_wide) tile_x = hexes_wide - 1;
	int tile_y = (point.y - ((tile_x % 2 == 1) ? 16 : 0)) / 32;
	if (tile_y >= hexes_high) tile_y = hexes_high - 1;
	
	return tileArray[tile_x][tile_y];
}

- (CGImageRef)getTerrainImageAtX:(int)x Y:(int)y {
	int terrainType = [[tileArray[x][y] valueForKey:@"terrainType"] intValue];
	return tileImageRefs[terrainType];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void)dealloc {
    [super dealloc];
}

@end
