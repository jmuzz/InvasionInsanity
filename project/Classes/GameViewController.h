@class GameView, GamePiece;

@protocol GameViewControllerDelegate;

typedef enum {
	waitingState,
	unitSelectedState,
	verifyMoveState,
	chooseTargetState,
	verifyAttackState
} GameState;

@interface GameViewController : UIViewController {
  @private
	GameView *gameView;
	id <GameViewControllerDelegate> delegate;
	GameState gameState;
	GamePiece *selectedPiece, *defendingPiece;
	int oldPieceX, oldPieceY, currentPlayerTurn;
	CALayer *selectedHex;
}

- (void)deselectPiece;
- (void)cancelMove;
- (void)finishMove;
- (void)endTurn;
- (void)refreshView;
- (void)skipAttack;
- (void)doAttack;

@property (nonatomic, retain) IBOutlet GameView *gameView;
@property (nonatomic, assign) id <GameViewControllerDelegate> delegate;
@property (nonatomic, readonly) int currentPlayerTurn;
@property (nonatomic, readonly) GameState gameState;
@property (nonatomic, readonly) GamePiece *selectedPiece, *defendingPiece;
@property (nonatomic, readonly) CALayer *selectedHex;

@end

@protocol GameViewControllerDelegate
- (void)showGameOver:(int)score;
@end