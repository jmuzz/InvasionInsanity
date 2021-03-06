#import "MenuViewController.h"
#import "GameViewController.h"
#import "GameOverViewController.h"

@interface InvasionInsanityAppDelegate : NSObject <UIApplicationDelegate, MenuViewControllerDelegate, GameViewControllerDelegate, GameOverViewControllerDelegate> {
  @private
    UIWindow *window;
	MenuViewController *menuViewController;
	GameViewController *gameViewController;
	GameOverViewController *gameOverViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) GameOverViewController *gameOverViewController;
@property (nonatomic, retain) MenuViewController *menuViewController;
@property (nonatomic, retain) GameViewController *gameViewController;

@end