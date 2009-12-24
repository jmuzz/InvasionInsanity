@class GameViewController;

@interface GameView : UIView {
	GameViewController *gameViewController;
	UIView *map;
}

@property (nonatomic, retain) IBOutlet GameViewController *gameViewController;

@end