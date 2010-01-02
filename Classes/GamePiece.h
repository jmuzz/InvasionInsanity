#define NUM_PIECE_TYPES 3

@class Map;

@interface GamePiece : CALayer {
	Map *map;
}

@property (nonatomic, retain) Map *map;

- (id)initWithPieceType:(int)type player:(int)player;

@end