#import "Map.h"
#import "GamePiece.h"
#import "GameViewController.h"

@implementation Map

@synthesize hexesWide, hexesHigh, gameViewController;

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
		int testPieces[12][4] = {
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

		hexesWide = MAP_WIDTH;
		hexesHigh = MAP_HEIGHT;
		gamePieces = [NSMutableArray arrayWithCapacity:12];
		[gamePieces retain];

		// Load tile images
		UIImage *tileImages = [UIImage imageNamed:@"hexes.png"];
		CGImageRef ir = CGImageCreateCopy([tileImages CGImage]);
		for (int i = 0; i < NUM_TILE_TYPES; i++) {
			tileImageRefs[i] = CGImageCreateWithImageInRect(ir, CGRectMake(i*36, 0, 36, 32));
		}

		// Load terrain data and create tile layers and add them to map
		CALayer *shadeMask = [CALayer layer];
		shadeMask.anchorPoint = CGPointMake(0.0f, 0.0f);
		shadeMask.bounds = CGRectMake(0.0f, 0.0f, 36.0f, 32.0f);
		shadeMask.contents = tileImageRefs[0];
		
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

				tileShade[i][j] = [CALayer layer];
				tileShade[i][j].anchorPoint = CGPointMake(0.0f, 0.0f);
				tileShade[i][j].position = CGPointMake(27.0f * i, 32.0f * j + ((i % 2 == 1) ? 16.0f : 0.0f));
				tileShade[i][j].bounds = CGRectMake(0.0f, 0.0f, 36.0f, 32.0f);
				tileShade[i][j].zPosition = 30.0f;
				//tileShade[i][j].opacity = 0.5f;

				CALayer *shadeMask = [CALayer layer];
				shadeMask.anchorPoint = CGPointMake(0.0f, 0.0f);
				shadeMask.bounds = CGRectMake(0.0f, 0.0f, 36.0f, 32.0f);
				shadeMask.contents = tileImageRefs[0];

				tileShade[i][j].mask = shadeMask;
				//tileShade[i][j].backgroundColor = [UIColor blackColor].CGColor;
				[[self layer] addSublayer:tileShade[i][j]];
			}
		}

		// Add some game pieces to the map
		for (int i = 0; i < 12; i++) {
			GamePiece *newPiece = [[GamePiece alloc] initWithPieceType:testPieces[i][0] player:testPieces[i][1]];
			[self addGamePiece:newPiece atX:testPieces[i][2] y:testPieces[i][3]];
		}
    }
    return self;
}

- (void)updateShades {
	[self clearShades];
	GamePiece *piece;
	switch (gameViewController.gameState) {
		case (unitSelectedState):
		case (verifyMoveState):
			piece = [gameViewController selectedPiece];
			tileShade[piece.x][piece.y].backgroundColor = [UIColor yellowColor].CGColor;
			tileShade[piece.x][piece.y].opacity = 0.5f;
			break;
			
		case (waitingState):
			for (piece in gamePieces) {
				if (piece.moved == false && piece.player == gameViewController.currentPlayerTurn) {
					tileShade[piece.x][piece.y].backgroundColor = [UIColor whiteColor].CGColor;
					tileShade[piece.x][piece.y].opacity = 0.5f;
				}
			}
			break;
	}
}

- (void)clearShades {
	for (int i = 0; i < MAP_WIDTH; i++) {
		for (int j = 0; j < MAP_HEIGHT; j++) {
			tileShade[i][j].opacity = 0.0f;
		}
	}
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
	int x = [self hexXFromPoint:point];
	if (x < 0 || x >= hexesWide) return nil;
	int y = [self hexYFromPoint:point];
	if (y < 0 || y >= hexesHigh) return nil;
	return tileArray[[self hexXFromPoint:point]][[self hexYFromPoint:point]];
}

- (int)hexXFromPoint:(CGPoint)point {
	return point.x / 27;
}

- (int)hexYFromPoint:(CGPoint)point {
	int x = [self hexXFromPoint:point];
	return (point.y - ((x % 2 == 1) ? 16 : 0)) / 32;
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

- (void)startNewTurn {
	GamePiece *piece;
	for (piece in gamePieces) {
		piece.moved = false;
	}
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
