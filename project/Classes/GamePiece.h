#define NUM_PIECE_TYPES 3

@class Map;

@interface GamePiece : CALayer {
  @private
	Map *map;
	int x, y, hp, attack, defense, maxMovement, curMovement, player, minRange, maxRange;
	NSString *title;
	bool moved;
}

@property (nonatomic, assign) Map *map;
@property (nonatomic, readonly) int x, y, hp, attack, defense, maxMovement, curMovement, player, minRange, maxRange;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic) bool moved;

- (id)initWithPieceType:(int)type player:(int)player;
- (void)setCoordsToX:(int)newX y:(int)newY;
- (void)moveToHex:(CALayer *)hex;
- (void)takeDamage:(int)damage;
- (void)resetMovement;

@end