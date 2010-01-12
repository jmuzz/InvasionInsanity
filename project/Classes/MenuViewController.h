@protocol MenuViewControllerDelegate;

@interface MenuViewController : UIViewController {
  @private
	UILabel *score;
	id <MenuViewControllerDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UILabel *score;
@property (nonatomic, assign) id <MenuViewControllerDelegate> delegate;

- (IBAction) play: (id) sender;
- (IBAction) help: (id) sender;

@end

@protocol MenuViewControllerDelegate
- (void)startGame;
@end