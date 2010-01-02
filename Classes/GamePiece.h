#define NUM_PIECE_TYPES 3

@class Map;

@interface GamePiece : CALayer {
	Map *map;
	int x, y;
}

@property (nonatomic, retain) Map *map;
@property (nonatomic, readonly) int x, y;

- (id)initWithPieceType:(int)type player:(int)player;
- (void)setCoordsToX:(int)new_x y:(int)new_y;

@end