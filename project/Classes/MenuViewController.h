@protocol MenuViewControllerDelegate;

@interface MenuViewController : UIViewController {
  @private
	UILabel *score;
	id <MenuViewControllerDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UILabel *score;
@property (nonatomic, assign) id <MenuViewControllerDelegate> delegate;

- (IBAction) map1: (id) sender;
- (IBAction) map2: (id) sender;
- (IBAction) map3: (id) sender;
- (IBAction) help: (id) sender;

@end

@protocol MenuViewControllerDelegate
- (void)startGame:(int)mapChoice;
@end