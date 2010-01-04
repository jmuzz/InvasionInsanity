@class GameViewController;
@class Map;
@class GamePiece;

@interface GameView : UIView {
	GameViewController *gameViewController;
	Map *map;
	CALayer *selectedTerrainPicture, *selectedPiecePicture;
	UIView *terrainInfoBar, *pieceInfoBar, *actionButtonBox;
	UILabel *terrainInfoText, *pieceInfoText;
	UIButton *endTurnButton;
}

- (void)updateTerrainInfoWithHex:(CALayer *)hex;
- (void)updatePieceInfoWithPiece:(GamePiece *)piece;

@property (nonatomic, retain) IBOutlet GameViewController *gameViewController;
@property (readonly, nonatomic, retain) Map *map;

@end