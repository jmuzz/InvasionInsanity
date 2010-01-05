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
}

- (void)deselectPiece;
- (void)cancelMove;
- (void)finishMove;

@property (nonatomic, retain) IBOutlet GameView *gameView;
@property (nonatomic, assign) id <GameViewControllerDelegate> delegate;

@end

@protocol GameViewControllerDelegate
- (void)showGameOver:(int)score;
@end