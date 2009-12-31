@class GameViewController;
@class Map;

@interface GameView : UIView {
	GameViewController *gameViewController;
	CALayer *selectedTerrainPicture;
	Map *map;
	UIView *terrainInfoBar;
}

- (void)updateTerrainInfoWithHex:(CALayer *)hex;

@property (nonatomic, retain) IBOutlet GameViewController *gameViewController;
@property (readonly, nonatomic, retain) Map *map;

@end