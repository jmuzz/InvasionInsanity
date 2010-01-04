@class GameView;

@protocol GameViewControllerDelegate;

typedef enum {
	waitingState,
	unitSelectedState
} GameState;

@interface GameViewController : UIViewController {
	GameView *gameView;
	id <GameViewControllerDelegate> delegate;
	GameState gameState;
}

@property (nonatomic, retain) IBOutlet GameView *gameView;
@property (nonatomic, assign) id <GameViewControllerDelegate> delegate;

@end

@protocol GameViewControllerDelegate
- (void)showGameOver:(int)score;
@end