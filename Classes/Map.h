#define NUM_TILE_TYPES 3
#define MAP_HEIGHT 10
#define MAP_WIDTH 10

@class GamePiece;

@interface Map : UIView {
	CALayer *tileArray[MAP_WIDTH][MAP_HEIGHT];
	int hexes_wide, hexes_high;
	CGImageRef tileImageRefs[NUM_TILE_TYPES];
	GamePiece *gamePiece;
}

@property (readonly, nonatomic) int hexes_wide, hexes_high;

- (CGImageRef)getTerrainImageAtX:(int)x Y:(int)y;
- (CALayer *)hexFromPoint:(CGPoint)point;

@end
