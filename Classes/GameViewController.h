@class GameView;

@protocol GameViewControllerDelegate;

@interface GameViewController : UIViewController {
	GameView *gameView;
	id <GameViewControllerDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet GameView *gameView;
@property (nonatomic, assign) id <GameViewControllerDelegate> delegate;

@end

@protocol GameViewControllerDelegate
- (void)showGameOver:(int)score;
@end