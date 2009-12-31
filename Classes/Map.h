#define NUM_TILE_TYPES 3
#define MAX_GAME_PIECES 20
#define MAP_HEIGHT 10
#define MAP_WIDTH 10

@class GamePiece;

@interface Map : UIView {
	CALayer *tileArray[MAP_WIDTH][MAP_HEIGHT];
	int hexes_wide, hexes_high;
	CGImageRef tileImageRefs[NUM_TILE_TYPES];
	GamePiece *gamePieces[MAX_GAME_PIECES];
}

@property (readonly, nonatomic) int hexes_wide, hexes_high;

// x and y refer to coordinates in the array of hexagons
// A CGPoint refers to a pixel coordinate in the map view
- (CGPoint)locationOfHexAtX:(int)x y:(int)y;
- (CGImageRef)getTerrainImageAtX:(int)x y:(int)y;
- (CALayer *)hexFromPoint:(CGPoint)point;
- (bool)addGamePiece:(GamePiece *)piece atX:(int)x y:(int)y;

@end
