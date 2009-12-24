@protocol GameOverViewControllerDelegate;

@interface GameOverViewController : UIViewController {
	id <GameOverViewControllerDelegate> delegate;
}

@property (nonatomic, retain) id <GameOverViewControllerDelegate> delegate;

- (IBAction) mainMenu: (id) sender;

@end

@protocol GameOverViewControllerDelegate
- (void) showMenu;
- (void) startGame;
@end