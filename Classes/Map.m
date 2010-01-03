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
			{1, 1, 1, 1, 2, 2, 2, 2, 0, 0},
			{2, 2, 2, 2, 1, 2, 2, 2, 2, 2},
			{2, 2, 2, 2, 1, 1, 2, 2, 2, 1},
			{0, 2, 2, 2, 2, 1, 2, 1, 1, 2},
			{0, 0, 2, 2, 2, 2, 1, 2, 2, 2},
			{0, 0, 0, 2, 2, 2, 1, 1, 2, 2},
			{0, 0, 0, 2, 2, 2, 2, 1, 2, 2}
		};
		
		// {type, player, x, y}
		int test_pieces[12][4] = {
			{2, 0, 0, 0},
			{1, 0, 1, 0},
			{1, 0, 0, 1},
			{0, 0, 2, 0},
			{0, 0, 0, 2},
			{0, 0, 2, 2},
			{2, 1, 9, 9},
			{1, 1, 8, 9},
			{1, 1, 9, 8},
			{0, 1, 7, 9},
			{0, 1, 9, 7},
			{0, 1, 7, 7}
		};

		hexes_wide = MAP_WIDTH;
		hexes_high = MAP_HEIGHT;
		gamePieces = [NSMutableArray arrayWithCapacity:12];
		[gamePieces retain];

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
				tileArray[i][j].zPosition = 10.0f;

				[[self layer] addSublayer:tileArray[i][j]];
			}
		}

		// Add some game pieces to the map
		for (int i = 0; i < 12; i++) {
			GamePiece *newPiece = [[GamePiece alloc] initWithPieceType:test_pieces[i][0] player:test_pieces[i][1]];
			[self addGamePiece:newPiece atX:test_pieces[i][2] y:test_pieces[i][3]];
		}
    }
    return self;
}

- (bool)addGamePiece:(GamePiece *)piece atX:(int)x y:(int)y {
	piece.anchorPoint = CGPointMake(0.0f, 0.0f);
	piece.zPosition = 20.0f;
	piece.map = self;
	[piece setCoordsToX:x y:y];
	[gamePieces insertObject:piece atIndex:0];
	[[self layer] addSublayer:piece];
	return true;
}

- (CGPoint)locationOfHexAtX:(int)x y:(int)y {
	return tileArray[x][y].position;
}

- (CALayer *)hexFromPoint:(CGPoint)point {
	return tileArray[[self hexXFromPoint:point]][[self hexYFromPoint:point]];
}

- (int)hexXFromPoint:(CGPoint)point {
	int ret = point.x / 27;
	return (ret >= hexes_wide) ? hexes_wide - 1 : ret;
}

- (int)hexYFromPoint:(CGPoint)point {
	int x = [self hexXFromPoint:point];
	int ret = (point.y - ((x % 2 == 1) ? 16 : 0)) / 32;
	return (ret >= hexes_high) ? hexes_high - 1 : ret;
}	

- (GamePiece *)pieceFromPoint:(CGPoint)point {
	int x = [self hexXFromPoint:point];
	int y = [self hexYFromPoint:point];
	
	GamePiece *piece;
	for (piece in gamePieces) {
		if (x == piece.x && y == piece.y) {
			return piece;
		}
	}

	return nil;
}

- (CGImageRef)getTerrainImageAtX:(int)x y:(int)y {
	int terrainType = [[tileArray[x][y] valueForKey:@"terrainType"] intValue];
	return tileImageRefs[terrainType];
}

/*- (void)drawRect:(CGRect)rect {
    // Drawing code
}*/

- (void)dealloc {
    [super dealloc];
	[gamePieces release];
}

@end
