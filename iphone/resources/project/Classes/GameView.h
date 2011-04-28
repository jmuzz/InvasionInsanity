#define NUM_ACTION_BUTTONS 10

@class GameViewController;
@class Map;
@class GamePiece;

@interface GameView : UIView {
  @private
	GameViewController *gameViewController;
	Map *map;
	CALayer *selectedTerrainPicture, *selectedPiecePicture;
	UIView *terrainInfoBar, *pieceInfoBar, *actionButtonBox;
	UILabel *terrainInfoText, *pieceInfoText;
	UIButton *actionButtons[NUM_ACTION_BUTTONS];
}

- (id)initWithFrame:(CGRect)frame mapChoice:(int)mapChoice;
- (void)updateTerrainInfoWithHex:(CALayer *)hex;
- (void)updatePieceInfoWithPiece:(GamePiece *)piece;
- (void)updateActionButtonBoxWithState:(int)state;

@property (nonatomic, retain) IBOutlet GameViewController *gameViewController;
@property (readonly, nonatomic, retain) Map *map;

@end