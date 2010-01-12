#import "Map.h"
#import "GamePiece.h"
#import "GameViewController.h"

@implementation Map

static const TerrainType terrainTypes[NUM_TILE_TYPES] = {
	{6, 0, @"Water"},
	{4, 6, @"Mountain"},
	{2, 2, @"Grass"},
	{3, 4, @"Forest"},
	{1, 1, @"Road"}
};

@synthesize hexesWide, hexesHigh, gameViewController;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		// Testmap 1
		int testMap[10][10] = {
			{2, 2, 2, 4, 2, 2, 0, 0, 0, 0},
			{2, 2, 2, 4, 1, 2, 0, 0, 0, 0},
			{2, 2, 4, 2, 2, 3, 2, 0, 0, 0},
			{4, 4, 4, 4, 3, 1, 3, 2, 0, 0},
			{2, 1, 3, 2, 4, 2, 2, 1, 2, 2},
			{1, 2, 2, 2, 4, 4, 3, 2, 2, 4},
			{0, 2, 2, 3, 2, 4, 2, 4, 4, 2},
			{0, 0, 1, 2, 3, 1, 4, 2, 2, 2},
			{0, 0, 0, 2, 2, 2, 4, 4, 2, 2},
			{0, 0, 0, 1, 2, 3, 2, 4, 2, 2}
		};
		
		// Testmap 2
		/*int testMap[9][11] = {
			{2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			{2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2},
			{2, 2, 2, 2, 2, 0, 0, 2, 2, 2, 2},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			{2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2},
			{2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2},
			{2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
			{2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2},
			{2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2}
		};*/
		
		// {type, player, x, y}
		// For testmap 1
		/*int testPieces[12][4] = {
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
		};*/
		
		// {type, player, x, y}
		// For testmap 1
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
	
		/* This set is close together */
		// For test map 2
		/*int testPieces[12][4] = {
		 {2, 0, 0, 4},
		 {1, 0, 1, 2},
		 {1, 0, 1, 5},
		 {0, 0, 2, 6},
		 {0, 0, 2, 4},
		 {0, 0, 2, 2},
		 {2, 1, 10, 4},
		 {1, 1, 9, 2},
		 {1, 1, 9, 5},
		 {0, 1, 8, 6},
		 {0, 1, 8, 4},
		 {0, 1, 8, 2}
		 };*/

		hexesWide = MAP_WIDTH;
		hexesHigh = MAP_HEIGHT;
		gamePieces = [NSMutableArray arrayWithCapacity:12];
		[gamePieces retain];

		// Load tile images
		UIImage *tileImages = [UIImage imageNamed:@"hexes.png"];
		CGImageRef ir = CGImageCreateCopy([tileImages CGImage]);
		[tileImages release];
		for (int i = 0; i < NUM_TILE_TYPES; i++) {
			tileImageRefs[i] = CGImageCreateWithImageInRect(ir, CGRectMake(i*36, 0, 36, 32));
		}
		CGImageRelease(ir);
		
		// Load hex highlight
		UIImage *highlightImage = [UIImage imageNamed:@"highlight.png"];
		CGImageRef ir2 = CGImageCreateCopy([highlightImage CGImage]);
		[highlightImage release];
		highlight = [[CALayer layer] retain];
		highlight.anchorPoint = CGPointMake(0.0f, 0.0f);
		highlight.bounds = CGRectMake(0.0f, 0.0f, 40.0f, 36.0f);
		highlight.zPosition = 50.0f;
		highlight.contents = ir2;
		highlight.position = CGPointMake(0.0f, 0.0f);
		
		UIImage *hexMask = [UIImage imageNamed:@"hexmask.png"];
		CGImageRef hexMaskRef = CGImageCreateCopy([hexMask CGImage]);
		[hexMask release];

		// Load terrain data and create tile layers and add them to map
		for (int i = 0; i < MAP_WIDTH; i++) {
			for (int j = 0; j < MAP_HEIGHT; j++) {
				tileArray[i][j] = [CALayer layer];
				tileArray[i][j].anchorPoint = CGPointMake(0.0f, 0.0f);
				tileArray[i][j].position = CGPointMake(27.0f * i, 32.0f * j + ((i % 2 == 1) ? 16.0f : 0.0f));
				tileArray[i][j].bounds = CGRectMake(0.0f, 0.0f, 36.0f, 32.0f);
				int terrainType = testMap[j][i];
				[tileArray[i][j] setValue:[NSNumber numberWithInteger:terrainType] forKey:@"terrainType"];
				[tileArray[i][j] setValue:[NSNumber numberWithInteger:i] forKey:@"hexX"];
				[tileArray[i][j] setValue:[NSNumber numberWithInteger:j] forKey:@"hexY"];
				tileArray[i][j].contents = tileImageRefs[terrainType];
				tileArray[i][j].zPosition = 10.0f;
				[[self layer] addSublayer:tileArray[i][j]];

				tileShade[i][j] = [CALayer layer];
				tileShade[i][j].anchorPoint = CGPointMake(0.0f, 0.0f);
				tileShade[i][j].position = CGPointMake(27.0f * i, 32.0f * j + ((i % 2 == 1) ? 16.0f : 0.0f));
				tileShade[i][j].bounds = CGRectMake(0.0f, 0.0f, 36.0f, 32.0f);
				tileShade[i][j].zPosition = 30.0f;

				CALayer *shadeMask = [CALayer layer];
				shadeMask.anchorPoint = CGPointMake(0.0f, 0.0f);
				shadeMask.bounds = CGRectMake(0.0f, 0.0f, 36.0f, 32.0f);
				shadeMask.contents = hexMaskRef;

				tileShade[i][j].mask = shadeMask;

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

- (TerrainType)typeOfHex:(CALayer *)hex {
	int type = [[hex valueForKey:@"terrainType"] intValue];
	return terrainTypes[type];
}

- (void)removeGamePiece:(GamePiece *)piece {
	[gamePieces removeObject:piece];
}

- (NSArray *)hexesInAttackRangeOfPiece:(GamePiece *)attackingPiece {
	NSMutableArray *ret = [NSMutableArray arrayWithCapacity:6];
	for (int i = 0; i < MAP_WIDTH; i++) {
		for (int j = 0; j < MAP_HEIGHT; j++) {
			int distance = [self distanceBetweenHex:tileArray[attackingPiece.x][attackingPiece.y] andHex:tileArray[i][j]];
			if (distance >= attackingPiece.minRange && distance <= attackingPiece.maxRange) {
				[ret addObject:tileArray[i][j]];
			}
		}
	}
	return ret;
}

- (NSArray *)piecesAttackableByPiece:(GamePiece *)attacker {
	NSMutableArray *ret = [NSMutableArray arrayWithCapacity:3];
	GamePiece *piece;
	for (piece in gamePieces) {
		if ([self pieceCanAttackDefender:piece attacker:attacker]) {
			[ret addObject:piece];
		}
	}
	return ret;
}

- (bool)pieceCanAttackDefender:(GamePiece *)defender attacker:(GamePiece *)attacker {
	if (attacker.player == defender.player) {
		return false;
	}
	int distance = [self distanceBetweenHex:tileArray[attacker.x][attacker.y] andHex:tileArray[defender.x][defender.y]];
	if (distance >= attacker.minRange && distance <= attacker.maxRange) {
		return true;
	}
	return false;
}

- (int)distanceBetweenHex:(CALayer *)hex1 andHex:(CALayer *)hex2 {
	int srcX     = [[hex1 valueForKey:@"hexX"] intValue];
	int srcY     = [[hex1 valueForKey:@"hexY"] intValue];
	int destX    = [[hex2 valueForKey:@"hexX"] intValue];
	int destY    = [[hex2 valueForKey:@"hexY"] intValue];
	int distance = 0;
	
	// Each iteration of this loop brings the source coordinates 1 hex closer to the destination
	while (srcX != destX || srcY != destY) {
		distance++;
		if (srcX == destX) {
			if (srcY < destY) {
				srcY++;
			} else {
				srcY--;
			}
		} else {
			if (srcX % 2 == 0) {
				if (srcY > destY) {
					srcY--;
				}
			} else {
				if (srcY < destY) {
					srcY++;
				}
			}
			if (srcX > destX) {
				srcX--;
			} else {
				srcX++;
			}
		}
	}
	
	return distance;
}

- (NSArray *)hexesInMovementRangeOfPiece:(GamePiece *)movingPiece {
	for (int i = 0; i < MAP_WIDTH; i++) {
		for (int j = 0; j < MAP_WIDTH; j++) {
			[tileArray[i][j] setValue:[NSNumber numberWithInteger:-1] forKey:@"movementLeft"];
		}
	}

	CALayer *hex = tileArray[movingPiece.x][movingPiece.y];
	[hex setValue:[NSNumber numberWithInteger:(movingPiece.movement)] forKey:@"movementLeft"];

	NSMutableArray *hexQueue = [NSMutableArray arrayWithCapacity:60];
	[hexQueue insertObject:hex atIndex:0];
	NSMutableArray *ret = [NSMutableArray arrayWithCapacity:60];
	[ret addObject:hex];

	while (hex = [hexQueue lastObject]) {
		[hexQueue removeLastObject];
		int movementLeft = [[hex valueForKey:@"movementLeft"] intValue];
		if (movementLeft != 0) {
			NSArray *closeHexes = [self hexesBesideHex:hex];
			CALayer *closeHex;
			for (closeHex in closeHexes) {
				int movementEstablished = [[closeHex valueForKey:@"movementLeft"] intValue];
				int newMovement;
				if ([self enemyZOCHasHex:closeHex]) {
					newMovement = 0;
				} else {
					newMovement = movementLeft - [self typeOfHex:closeHex].movementCost;
				}
				if (newMovement > movementEstablished) {
					[closeHex setValue:[NSNumber numberWithInteger:(newMovement)] forKey:@"movementLeft"];
					[ret addObject:closeHex];
					[hexQueue insertObject:closeHex atIndex:0];
				}
			}
		}
	}

	GamePiece *piece;
	for (piece in gamePieces) {
		[ret removeObject:tileArray[piece.x][piece.y]];
	}

	return ret;
}

- (NSArray *)hexesBesideHex:(CALayer *)hex {
	int x = [[hex valueForKey:@"hexX"] intValue];
	int y = [[hex valueForKey:@"hexY"] intValue];
	int otherY;
	if (x % 2 == 1) {
		otherY = y + 1;
	} else {
		otherY = y - 1;
	}

	int coordinates[6][2] = {
		{x, y + 1},
		{x, y - 1},
		{x + 1, y},
		{x - 1, y},
		{x + 1, otherY},
		{x - 1, otherY}
	};

	NSMutableArray *ret = [NSMutableArray arrayWithCapacity:6];
	for (int i = 0; i < 6; i ++) {
		if (coordinates[i][0] >= 0 && coordinates[i][0] < MAP_WIDTH && coordinates[i][1] >= 0 && coordinates[i][1] < MAP_WIDTH) {
			[ret addObject:tileArray[coordinates[i][0]][coordinates[i][1]]];
		}
	}

	return ret;
}

- (void)updateShades {
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:0.0f] forKey:kCATransactionAnimationDuration];
	
	[self clearShades];
	GamePiece *piece;
	NSArray *pieces;
	NSArray *hexes;
	CALayer *hex;
	int x, y;
	
	switch (gameViewController.gameState) {
		case (unitSelectedState):
			piece = gameViewController.selectedPiece;
			highlight.position = CGPointMake(piece.position.x - 2.0f, piece.position.y - 2.0f);
			[self.layer addSublayer:highlight];

			CABasicAnimation *theAnimation;
			theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
			theAnimation.duration=0.5;
			theAnimation.repeatCount=2000000;
			theAnimation.autoreverses=YES;
			theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
			theAnimation.toValue=[NSNumber numberWithFloat:0.0];
			[highlight addAnimation:theAnimation forKey:@"animateOpacity"];

			hexes = [self hexesInMovementRangeOfPiece:piece];
			for (hex in hexes) {
				x = [[hex valueForKey:@"hexX"] intValue];
				y = [[hex valueForKey:@"hexY"] intValue];
				tileShade[x][y].backgroundColor = [UIColor purpleColor].CGColor;
				tileShade[x][y].opacity = 0.5f;
			}
			break;
			
		case (verifyMoveState):
			piece = gameViewController.selectedPiece;
			tileShade[piece.x][piece.y].backgroundColor = [UIColor yellowColor].CGColor;
			tileShade[piece.x][piece.y].opacity = 0.5f;
			
			hexes = [self hexesInAttackRangeOfPiece:piece];
			for (hex in hexes) {
				x = [[hex valueForKey:@"hexX"] intValue];
				y = [[hex valueForKey:@"hexY"] intValue];
				tileShade[x][y].backgroundColor = [UIColor redColor].CGColor;
				tileShade[x][y].opacity = 0.5f;
			}
			break;
			
		case (chooseTargetState):
			piece = gameViewController.selectedPiece;
			tileShade[piece.x][piece.y].backgroundColor = [UIColor yellowColor].CGColor;
			tileShade[piece.x][piece.y].opacity = 0.5f;
			
			pieces = [self piecesAttackableByPiece:piece];
			for (piece in pieces) {
				tileShade[piece.x][piece.y].backgroundColor = [UIColor redColor].CGColor;
				tileShade[piece.x][piece.y].opacity = 0.5f;
			}
			break;
			
		case (verifyAttackState):
			piece = gameViewController.selectedPiece;
			tileShade[piece.x][piece.y].backgroundColor = [UIColor yellowColor].CGColor;
			tileShade[piece.x][piece.y].opacity = 0.5f;
			
			piece = gameViewController.defendingPiece;
			tileShade[piece.x][piece.y].backgroundColor = [UIColor redColor].CGColor;
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
	
	[CATransaction commit];
}

- (void)clearShades {
	[highlight removeFromSuperlayer];
	for (int i = 0; i < MAP_WIDTH; i++) {
		for (int j = 0; j < MAP_HEIGHT; j++) {
			tileShade[i][j].opacity = 0.0f;
			tileShade[i][j].backgroundColor = nil;
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

- (int)numSupportingUnitsWithAttacker:(GamePiece *)attacker defender:(GamePiece *)defender {
	int ret = 0;
	NSArray *hexes = [self hexesBesideHex:tileArray[defender.x][defender.y]];
	GamePiece *piece;
	CALayer *hex;
	
	for (hex in hexes) {
		piece = [self pieceOnHex:hex];
		if (piece && piece != attacker && piece.player == attacker.player) {
			ret++;
		}
	}
	
	return ret;
}

- (bool)enemyPieceOnHex:(CALayer *)hex {
	GamePiece *piece = [self pieceOnHex:hex];
	if (piece && piece.player != gameViewController.currentPlayerTurn) {
		return true;
	}
	return false;
}

- (bool)enemyZOCHasHex:(CALayer *)hex {
	if ([self enemyPieceOnHex:hex]) {
		return true;
	}
	NSArray *hexes = [self hexesBesideHex:hex];
	CALayer *closeHex;
	for (closeHex in hexes) {
		if ([self enemyPieceOnHex:closeHex]) {
			return true;
		}
	}
	return false;
}

- (GamePiece *)pieceOnHex:(CALayer *)hex {
	int x = [[hex valueForKey:@"hexX"] intValue];
	int y = [[hex valueForKey:@"hexY"] intValue];
	GamePiece *piece;
	for (piece in gamePieces) {
		if (piece.x == x && piece.y == y) {
			return piece;
		}
	}
	return nil;
}

- (CGPoint)locationOfHexAtX:(int)x y:(int)y {
	return tileArray[x][y].position;
}

- (bool)pieceCanMoveToHex:(CALayer *)dest piece:(GamePiece *)piece {
	NSArray *validHexes = [self hexesInMovementRangeOfPiece:piece];
	CALayer *hex;
	for (hex in validHexes) {
		if ([self hexesAreEqual:hex otherHex:dest]) {
			return true;
		}
	}
	return false;
}

- (bool)hexesAreEqual:(CALayer *)hex otherHex:(CALayer *)otherHex {
	int x      = [[hex      valueForKey:@"hexX"] intValue];
	int otherX = [[otherHex valueForKey:@"hexX"] intValue];
	int y      = [[hex      valueForKey:@"hexY"] intValue];
	int otherY = [[otherHex valueForKey:@"hexY"] intValue];
	
	if (x != otherX)
		return false;
	return (y == otherY);
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
	return [self pieceOnHex:[self hexFromPoint:point]];
}

- (CALayer *)hexUnderPiece:(GamePiece *)piece {
	return tileArray[piece.x][piece.y];
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
