#define NUM_ACTION_BUTTONS 3

@class GameViewController;
@class Map;
@class GamePiece;

@interface GameView : UIView {
	GameViewController *gameViewController;
	Map *map;
	CALayer *selectedTerrainPicture, *selectedPiecePicture;
	UIView *terrainInfoBar, *pieceInfoBar, *actionButtonBox;
	UILabel *terrainInfoText, *pieceInfoText;
	UIButton *actionButtons[NUM_ACTION_BUTTONS];
}

- (void)updateTerrainInfoWithHex:(CALayer *)hex;
- (void)updatePieceInfoWithPiece:(GamePiece *)piece;
- (void)updateActionButtonBoxWithState:(int)state;

@property (nonatomic, retain) IBOutlet GameViewController *gameViewController;
@property (readonly, nonatomic, retain) Map *map;

@end