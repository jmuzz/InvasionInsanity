#define NUM_TILE_TYPES 3
#define MAP_HEIGHT 10
#define MAP_WIDTH 10

@class GamePiece;

@interface Map : UIView {
	CALayer *tileArray[MAP_WIDTH][MAP_HEIGHT];
	int hexesWide, hexesHigh;
	CGImageRef tileImageRefs[NUM_TILE_TYPES];
	NSMutableArray *gamePieces;
}

@property (readonly, nonatomic) int hexesWide, hexesHigh;

// x and y refer to coordinates in the array of hexagons
// A CGPoint refers to a pixel coordinate in the map view
- (CGPoint)locationOfHexAtX:(int)x y:(int)y;
- (CGImageRef)getTerrainImageAtX:(int)x y:(int)y;
- (CALayer *)hexFromPoint:(CGPoint)point;
- (GamePiece *)pieceFromPoint:(CGPoint)point;
- (bool)addGamePiece:(GamePiece *)piece atX:(int)x y:(int)y;
- (int)hexXFromPoint:(CGPoint)point;
- (int)hexYFromPoint:(CGPoint)point;

@end