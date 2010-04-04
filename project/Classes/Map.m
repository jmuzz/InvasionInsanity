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

- (id)initWithFrame:(CGRect)frame mapChoice:(int)mapChoice{
    if (self = [super initWithFrame:frame]) {
		NSMutableArray *mapInit;
		NSMutableArray *piecesInit;
		
		switch (mapChoice) {
			case 1:
				hexesWide = 10;
				hexesHigh = 10;
				mapInit = [NSMutableArray arrayWithCapacity:hexesWide];
				
				// Testmap 1
				int testMap1[10][10] = {
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
				
				// This is gonna be duplicated for now but should be DRY in the final version
				for (int i = 0; i < hexesWide; i++) {
					NSMutableArray *mapInitColumn = [NSMutableArray arrayWithCapacity:hexesHigh];
					for (int j = 0; j < hexesHigh; j++) {
						[mapInitColumn addObject:[NSNumber numberWithInteger:testMap1[j][i]]];
					}
					[mapInit addObject:mapInitColumn];
				}

				// {type, player, x, y}
				// For testmap 1
				int testPieces1[12][4] = {
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
				
				// More code to DRY or eliminate in final version
				piecesInit = [NSMutableArray arrayWithCapacity:12];
				for (int i = 0; i < 12; i++) {
					NSMutableArray *pieceInit = [NSMutableArray arrayWithCapacity:4];
					for (int j = 0; j < 4; j++) {
						[pieceInit addObject:[NSNumber numberWithInteger:testPieces1[i][j]]];
					}
					[piecesInit addObject:pieceInit];
				}

				break;
				
			case 2:
				hexesWide = 11;
				hexesHigh = 9;
				mapInit = [NSMutableArray arrayWithCapacity:hexesWide];
				
				int testMap2[9][11] = {
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
				};
				
				// This is gonna be duplicated for now but should be DRY in the final version
				for (int i = 0; i < hexesWide; i++) {
					NSMutableArray *mapInitColumn = [NSMutableArray arrayWithCapacity:hexesHigh];
					for (int j = 0; j < hexesHigh; j++) {
						[mapInitColumn addObject:[NSNumber numberWithInteger:testMap2[j][i]]];
					}
					[mapInit addObject:mapInitColumn];
				}
				
				/* This set is close together */
				int testPieces2[12][4] = {
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
				};
				
				// More code to DRY or eliminate in final version
				piecesInit = [NSMutableArray arrayWithCapacity:12];
				for (int i = 0; i < 12; i++) {
					NSMutableArray *pieceInit = [NSMutableArray arrayWithCapacity:4];
					for (int j = 0; j < 4; j++) {
						[pieceInit addObject:[NSNumber numberWithInteger:testPieces2[i][j]]];
					}
					[piecesInit addObject:pieceInit];
				}
				
				break;
		}

		gamePieces = [NSMutableArray arrayWithCapacity:12];
		[gamePieces retain];

		// Load tile images
		UIImage *image = [UIImage imageNamed:@"hexes.png"];
		CGImageRef ir = CGImageCreateCopy([image CGImage]);
		[image release];
		for (int i = 0; i < NUM_TILE_TYPES; i++) {
			tileImageRefs[i] = CGImageCreateWithImageInRect(ir, CGRectMake(i*36, 0, 36, 32));
		}
		CGImageRelease(ir);

		// Load hex highlight
		image = [UIImage imageNamed:@"highlight.png"];
		ir = CGImageCreateCopy([image CGImage]);
		[image release];
		highlight = [[CALayer layer] retain];
		highlight.anchorPoint = CGPointMake(0.0f, 0.0f);
		highlight.bounds = CGRectMake(0.0f, 0.0f, 40.0f, 36.0f);
		highlight.zPosition = 50.0f;
		highlight.contents = ir;

		highlight.position = CGPointMake(0.0f, 0.0f);
		[self.layer addSublayer:highlight];

		CABasicAnimation *theAnimation;
		theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
		theAnimation.duration=1.0;
		theAnimation.repeatCount=2000000;
		theAnimation.autoreverses=YES;
		theAnimation.fromValue=[NSNumber numberWithFloat:0.5f];
		theAnimation.toValue=[NSNumber numberWithFloat:0.0f];
		[highlight addAnimation:theAnimation forKey:@"animateOpacity"];
		
		[highlight removeFromSuperlayer];
		
		// Load target graphic
		image = [UIImage imageNamed:@"attack.png"];
		ir = CGImageCreateCopy([image CGImage]);
		[image release];
		target = [[CALayer layer] retain];
		target.anchorPoint = CGPointMake(0.0f, 0.0f);
		target.bounds = CGRectMake(0.0f, 0.0f, 40.0f, 36.0f);
		target.zPosition = 50.0f;
		target.contents = ir;
		target.position = CGPointMake(0.0f, 0.0f);
		target.opacity = 0.7f;

		UIImage *hexMask = [UIImage imageNamed:@"hexmask.png"];
		CGImageRef hexMaskRef = CGImageCreateCopy([hexMask CGImage]);
		[hexMask release];

		// Load terrain data and create tile layers and add them to map
		tileArray = [[NSMutableArray alloc] initWithCapacity:hexesWide];
		shadeArray = [[NSMutableArray alloc] initWithCapacity:hexesHigh];
		
		for (int i = 0; i < hexesWide; i++) {
			NSMutableArray *mapInitColumn = [mapInit objectAtIndex:i];
			NSMutableArray *tileColumn = [[NSMutableArray alloc] initWithCapacity:hexesHigh];
			NSMutableArray *shadeColumn = [[NSMutableArray alloc] initWithCapacity:hexesHigh];
			
			for (int j = 0; j < hexesHigh; j++) {
				NSNumber *tileTypeObj = [mapInitColumn objectAtIndex:j];
				int terrainType = [tileTypeObj intValue];
				CALayer *hex = [CALayer layer];
				hex.anchorPoint = CGPointMake(0.0f, 0.0f);
				hex.position = CGPointMake(27.0f * i, 32.0f * j + ((i % 2 == 1) ? 16.0f : 0.0f));
				hex.bounds = CGRectMake(0.0f, 0.0f, 36.0f, 32.0f);
				[hex setValue:[NSNumber numberWithInteger:terrainType] forKey:@"terrainType"];
				[hex setValue:[NSNumber numberWithInteger:i] forKey:@"hexX"];
				[hex setValue:[NSNumber numberWithInteger:j] forKey:@"hexY"];
				hex.contents = tileImageRefs[terrainType];
				hex.zPosition = 10.0f;
				[[self layer] addSublayer:hex];
				[tileColumn addObject:hex];
				
				CALayer *shade = [[CALayer layer] retain];
				shade.anchorPoint = CGPointMake(0.0f, 0.0f);
				shade.position = CGPointMake(27.0f * i, 32.0f * j + ((i % 2 == 1) ? 16.0f : 0.0f));
				shade.bounds = CGRectMake(0.0f, 0.0f, 36.0f, 32.0f);
				shade.zPosition = 30.0f;
				
				CALayer *shadeMask = [[CALayer layer] retain];
				shadeMask.anchorPoint = CGPointMake(0.0f, 0.0f);
				shadeMask.bounds = CGRectMake(0.0f, 0.0f, 36.0f, 32.0f);
				shadeMask.contents = hexMaskRef;
				
				shade.mask = shadeMask;
				
				[[self layer] addSublayer:shade];
				[shadeColumn addObject:shade];
			}
			
			[tileArray addObject:tileColumn];
			[shadeArray addObject:shadeColumn];
		}

		// Add some game pieces to the map
		for (NSArray *pieceInit in piecesInit) {
			GamePiece *newPiece = [[GamePiece alloc] initWithPieceType:[[pieceInit objectAtIndex:0] intValue] player:[[pieceInit objectAtIndex:1] intValue]];
			[self addGamePiece:newPiece atX:[[pieceInit objectAtIndex:2] intValue] y:[[pieceInit objectAtIndex:3] intValue]];
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

- (void)clearUndo {
	GamePiece *piece;
	for (piece in gamePieces) {
		if (piece.player == gameViewController.currentPlayerTurn) {
			[piece resetUndo];
		}
	}
}

- (NSArray *)hexesInAttackRangeOfPiece:(GamePiece *)attackingPiece {
	NSMutableArray *ret = [NSMutableArray arrayWithCapacity:6];
	for (int i = 0; i < hexesWide; i++) {
		for (int j = 0; j < hexesHigh; j++) {
			int distance = [self distanceBetweenHex:[self hexAtLocationX:attackingPiece.x y:attackingPiece.y] andHex:[self hexAtLocationX:i y:j]];
			if (distance >= attackingPiece.minRange && distance <= attackingPiece.maxRange) {
				[ret addObject:[self hexAtLocationX:i y:j]];
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
	int distance = [self distanceBetweenHex:[self hexAtLocationX:attacker.x y:attacker.y] andHex:[self hexAtLocationX:defender.x y:defender.y]];
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
	for (int i = 0; i < hexesWide; i++) {
		for (int j = 0; j < hexesHigh; j++) {
			[[self hexAtLocationX:i y:j] setValue:[NSNumber numberWithInteger:-1] forKey:@"movementLeft"];
		}
	}

	CALayer *hex = [self hexAtLocationX:movingPiece.x y:movingPiece.y];
	[hex setValue:[NSNumber numberWithInteger:(movingPiece.curMovement)] forKey:@"movementLeft"];

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
					if (newMovement < 0) {
						newMovement = 0;
					}
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
		[ret removeObject:[self hexAtLocationX:piece.x y:piece.y]];
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
		if (coordinates[i][0] >= 0 && coordinates[i][0] < hexesWide && coordinates[i][1] >= 0 && coordinates[i][1] < hexesHigh) {
			[ret addObject:[self hexAtLocationX:coordinates[i][0] y:coordinates[i][1]]];
		}
	}

	return ret;
}

- (void)updateShades {
	[CATransaction begin];
	[CATransaction setValue:[NSNumber numberWithFloat:0.0f] forKey:kCATransactionAnimationDuration];
	
	[self clearShades];
	GamePiece *piece, *attackablePiece;
	NSArray *pieces;
	NSArray *hexes;
	CALayer *hex;
	int x, y;
	
	switch (gameViewController.gameState) {
		default:
		case (waitingState):
			for (piece in gamePieces) {
				if (piece.player == gameViewController.currentPlayerTurn) {
					CALayer *shade = [self shadeAtLocationX:piece.x y:piece.y];
					if ([piece canBeUsed]) {
						shade.backgroundColor = [UIColor whiteColor].CGColor;
						shade.opacity = 0.35f;
					} else {
						shade.backgroundColor = [UIColor blackColor].CGColor;
						shade.opacity = 0.3f;
					}
				}
			}
			
			hex = gameViewController.selectedHex;
			highlight.position = CGPointMake(hex.position.x - 2.0f, hex.position.y - 2.0f);
			[self.layer addSublayer:highlight];
			break;

		case (unitSelectedState):
			// Add unit cursor
			piece = gameViewController.selectedPiece;
			highlight.position = CGPointMake(piece.position.x - 2.0f, piece.position.y - 2.0f);
			[self.layer addSublayer:highlight];
			
			// Highlight attackable pieces
			pieces = [self piecesAttackableByPiece:piece];
			for (attackablePiece in pieces) {
				CALayer *shade = [self shadeAtLocationX:attackablePiece.x y:attackablePiece.y];
				shade.backgroundColor = [UIColor redColor].CGColor;
				shade.opacity = 0.3f;
			}

			// Highlight movement range
			hexes = [self hexesInMovementRangeOfPiece:piece];
			for (hex in hexes) {
				x = [[hex valueForKey:@"hexX"] intValue];
				y = [[hex valueForKey:@"hexY"] intValue];
				CALayer *shade = [self shadeAtLocationX:x y:y];
				shade.backgroundColor = [UIColor purpleColor].CGColor;
				shade.opacity = 0.3f;
			}
			break;
			
		case (verifyAttackState):
			[self.layer addSublayer:highlight];
			
			piece = gameViewController.defendingPiece;
			target.position = CGPointMake(piece.position.x - 2.0f, piece.position.y - 2.0f);
			[self.layer addSublayer:target];
			break;
	}
	
	[CATransaction commit];
}

- (void)clearShades {
	[highlight removeFromSuperlayer];
	[target removeFromSuperlayer];
	for (int i = 0; i < hexesWide; i++) {
		for (int j = 0; j < hexesHigh; j++) {
			CALayer *shade = [self shadeAtLocationX:i y:j];
			shade.opacity = 0.9f;
			shade.backgroundColor = nil;
		}
	}
}

- (GamePiece *)firstUsableUnit {
	GamePiece *piece;
	for (piece in gamePieces) {
		if ([piece canBeUsed] && piece.player == gameViewController.currentPlayerTurn) {
			return piece;
		}
	}
	return nil;
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
	NSArray *hexes = [self hexesBesideHex:[self hexAtLocationX:defender.x y:defender.y]];
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

- (GamePiece *)pieceAtLocationX:(int)x y:(int)y {
	GamePiece *piece;
	for (piece in gamePieces) {
		if (piece.x == x && piece.y == y) {
			return piece;
		}
	}
	return nil;
}

- (GamePiece *)pieceOnHex:(CALayer *)hex {
	int x = [[hex valueForKey:@"hexX"] intValue];
	int y = [[hex valueForKey:@"hexY"] intValue];
	return [self pieceAtLocationX:x y:y];
}

- (CGPoint)locationOfHexAtX:(int)x y:(int)y {
	CALayer *hex = [self hexAtLocationX:x y:y];
	return hex.position;
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

- (CALayer *)hexAtLocationX:(int)x y:(int)y {
	return [[tileArray objectAtIndex:x] objectAtIndex:y];
}

- (CALayer *)shadeAtLocationX:(int)x y:(int)y {
	return [[shadeArray objectAtIndex:x] objectAtIndex:y];
}

- (CALayer *)hexFromPoint:(CGPoint)point {
	int x = [self hexXFromPoint:point];
	if (x < 0 || x >= hexesWide) return nil;
	int y = [self hexYFromPoint:point];
	if (y < 0 || y >= hexesHigh) return nil;
	
	return [self hexAtLocationX:x y:y];
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
	return [self hexAtLocationX:piece.x y:piece.y];
}

- (void)startNewTurn {
	GamePiece *piece;
	for (piece in gamePieces) {
		[piece resetMovement];
	}
}

- (CGImageRef)getTerrainImageAtX:(int)x y:(int)y {
	CALayer *hex = [self hexAtLocationX:x y:y];
	int terrainType = [[hex valueForKey:@"terrainType"] intValue];
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
