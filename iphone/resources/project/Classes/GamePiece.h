#define NUM_PIECE_TYPES 3

@class Map;

@interface GamePiece : CALayer {
  @private
	Map *map;
	int x, y, hp, attack, defense, maxMovement, curMovement, player, minRange, maxRange;
	int undoX, undoY, undoMovement;
	NSString *title;
	bool didAttack, canUndo;
}

@property (nonatomic, assign) Map *map;
@property (nonatomic, readonly) int x, y, hp, attack, defense, maxMovement, curMovement, player, minRange, maxRange;
@property (nonatomic, readonly) bool didAttack, canUndo;
@property (nonatomic, readonly) NSString *title;

- (id)initWithPieceType:(int)type player:(int)player;
- (void)setCoordsToX:(int)newX y:(int)newY;
- (void)moveToHex:(CALayer *)hex;
- (void)takeDamage:(int)damage;
- (void)afterAttack;
- (void)resetMovement;
- (bool)canAttack;
- (void)wasteMovement;
- (bool)canBeUsed;
- (bool)canBeSelected;
- (void)resetUndo;
- (void)undo;

@end