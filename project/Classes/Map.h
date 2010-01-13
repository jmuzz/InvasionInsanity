#define NUM_TILE_TYPES 5
#define MAP_HEIGHT 10
#define MAP_WIDTH 10

@class GamePiece;
@class GameViewController;

typedef struct {
	int movementCost;
	int defenseBonus;
	NSString *name;
} TerrainType;

@interface Map : UIView {
  @private
	CALayer *tileArray[MAP_WIDTH][MAP_HEIGHT];
	CALayer *tileShade[MAP_WIDTH][MAP_HEIGHT];
	CALayer *highlight;
	int hexesWide, hexesHigh;
	CGImageRef tileImageRefs[NUM_TILE_TYPES];
	NSMutableArray *gamePieces;
	GameViewController *gameViewController;
}

@property (readonly, nonatomic) int hexesWide, hexesHigh;
@property (nonatomic, assign) GameViewController *gameViewController;

// x and y refer to coordinates in the array of hexagons
// A CGPoint refers to a pixel coordinate in the map view
- (CGPoint)locationOfHexAtX:(int)x y:(int)y;
- (CGImageRef)getTerrainImageAtX:(int)x y:(int)y;
- (CALayer *)hexFromPoint:(CGPoint)point;
- (GamePiece *)pieceFromPoint:(CGPoint)point;
- (bool)addGamePiece:(GamePiece *)piece atX:(int)x y:(int)y;
- (void)removeGamePiece:(GamePiece *)piece;
- (int)hexXFromPoint:(CGPoint)point;
- (int)hexYFromPoint:(CGPoint)point;
- (void)startNewTurn;
- (void)clearShades;
- (void)updateShades;
- (NSArray *)hexesBesideHex:(CALayer *)hex;
- (NSArray *)hexesInMovementRangeOfPiece:(GamePiece *)movingPiece;
- (NSArray *)hexesInAttackRangeOfPiece:(GamePiece *)attackingPiece;
- (bool)pieceCanMoveToHex:(CALayer *)dest piece:(GamePiece *)piece;
- (bool)pieceCanAttackDefender:(GamePiece *)defender attacker:(GamePiece *)attacker;
- (bool)hexesAreEqual:(CALayer *)hex otherHex:(CALayer *)otherHex;
- (int)distanceBetweenHex:(CALayer *)hex1 andHex:(CALayer *)hex2;
- (NSArray *)piecesAttackableByPiece:(GamePiece *)attacker;
- (GamePiece *)firstUsableUnit;
- (int)numSupportingUnitsWithAttacker:(GamePiece *)attacker defender:(GamePiece *)defender;
- (GamePiece *)pieceOnHex:(CALayer *)hex;
- (bool)enemyZOCHasHex:(CALayer *)hex;
- (bool)enemyPieceOnHex:(CALayer *)hex;
- (CALayer *)hexUnderPiece:(GamePiece *)piece;
- (TerrainType)typeOfHex:(CALayer *)hex;

@end