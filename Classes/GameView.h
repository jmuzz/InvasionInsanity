@class GameViewController;
@class Map;
@class GamePiece;

@interface GameView : UIView {
	GameViewController *gameViewController;
	CALayer *selectedTerrainPicture;
	CALayer *selectedPiecePicture;
	Map *map;
	UIView *terrainInfoBar;
	UIView *pieceInfoBar;
}

- (void)updateTerrainInfoWithHex:(CALayer *)hex;
- (void)updatePieceInfoWithPiece:(GamePiece *)piece;

@property (nonatomic, retain) IBOutlet GameViewController *gameViewController;
@property (readonly, nonatomic, retain) Map *map;

@end