@class GameViewController;

@interface GameView : UIView {
	GameViewController *gameViewController;
	UIImageView *player;
}

@property (nonatomic, retain) IBOutlet GameViewController *gameViewController;

@end