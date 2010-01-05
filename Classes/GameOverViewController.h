@protocol GameOverViewControllerDelegate;

@interface GameOverViewController : UIViewController {
  @private
	id <GameOverViewControllerDelegate> delegate;
}

@property (nonatomic, assign) id <GameOverViewControllerDelegate> delegate;

- (IBAction) mainMenu: (id) sender;

@end

@protocol GameOverViewControllerDelegate
- (void) showMenu;
- (void) startGame;
@end