@class Map;

@interface GamePiece : CALayer {
	Map *map;
}

@property (nonatomic, retain) Map *map;

- (id)initWithPieceType:(int)type;

@end