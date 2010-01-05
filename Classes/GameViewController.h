@class GameView, GamePiece;

@protocol GameViewControllerDelegate;

typedef enum {
	waitingState,
	unitSelectedState,
	verifyMoveState
} GameState;

@interface GameViewController : UIViewController {
	GameView *gameView;
	id <GameViewControllerDelegate> delegate;
	GameState gameState;
	GamePiece *selectedPiece;
	int oldPieceX, oldPieceY, currentPlayerTurn;
	CALayer *selectedHex;
}

- (void)deselectPiece;
- (void)cancelMove;
- (void)finishMove;
- (void)endTurn;
- (void)refreshView;

@property (nonatomic, retain) IBOutlet GameView *gameView;
@property (nonatomic, assign) id <GameViewControllerDelegate> delegate;
@property (nonatomic, readonly) int currentPlayerTurn;
@property (nonatomic, readonly) GameState gameState;
@property (nonatomic, readonly) GamePiece *selectedPiece;

@end

@protocol GameViewControllerDelegate
- (void)showGameOver:(int)score;
@end