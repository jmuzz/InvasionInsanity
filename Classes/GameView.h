@class GameViewController;

#define NUM_TILE_TYPES 3

@interface GameView : UIView {
	int gameTerrain[10][10];
	GameViewController *gameViewController;
	CALayer *tileArray[10][10];
	CALayer *selectedTerrainPicture;
	UIView *map;
	UIView *terrainInfoBar;
	CGImageRef tileImageRefs[NUM_TILE_TYPES];
}

- (void)updateTerrainInfoWithX:(int)x Y:(int)y;

@property (nonatomic, retain) IBOutlet GameViewController *gameViewController;

@end