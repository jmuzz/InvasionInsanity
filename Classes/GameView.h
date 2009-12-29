@class GameViewController;

#define NUM_TILE_TYPES 3
#define MAP_HEIGHT 10
#define MAP_WIDTH 10

@interface GameView : UIView {
	int hexes_wide, hexes_high;
	GameViewController *gameViewController;
	CALayer *tileArray[MAP_WIDTH][MAP_HEIGHT];
	CALayer *selectedTerrainPicture;
	UIView *map;
	UIView *terrainInfoBar;
	CGImageRef tileImageRefs[NUM_TILE_TYPES];
}

- (void)updateTerrainInfoWithX:(int)x Y:(int)y;

@property (nonatomic, retain) IBOutlet GameViewController *gameViewController;
@property (readonly, nonatomic, retain) UIView *map;
@property (readonly, nonatomic) int hexes_wide, hexes_high;

@end