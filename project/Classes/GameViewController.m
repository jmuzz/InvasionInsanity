#import "GameViewController.h"
#import "GameView.h"
#import "Map.h"
#import "GamePiece.h"

@implementation GameViewController

@synthesize gameView, delegate, currentPlayerTurn, gameState, selectedPiece, defendingPiece, selectedHex;

- (void) loadView {
	self.wantsFullScreenLayout = YES;

	GameView *view = [[GameView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	view.gameViewController = self;
	self.view = view;
	self.gameView = view;
	gameState = waitingState;
	currentPlayerTurn = 0;
	view.map.gameViewController = self;
	[self refreshView];
	[view release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		switch (currentPlayerTurn) {
			case (0):
				currentPlayerTurn = 1;
				break;
				
			case (1):
				currentPlayerTurn = 0;
				break;
		}
		
		[gameView.map startNewTurn];
		[self refreshView];
	}
}

- (void)endTurn {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"End your turn" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[alert show];
	[alert release];
}

- (void)doAttack {
	Map *map = gameView.map;
	int attackerSupport = [map numSupportingUnitsWithAttacker:selectedPiece defender:defendingPiece];
	int defenderSupport = [map numSupportingUnitsWithAttacker:defendingPiece defender:selectedPiece];
	int attackerTerrainDefense = [map typeOfHex:[map hexUnderPiece:selectedPiece]].defenseBonus;
	int defenderTerrainDefense = [map typeOfHex:[map hexUnderPiece:defendingPiece]].defenseBonus;
	int attackerDoesDamage = 0;

	for (int i = 0; i < (selectedPiece.attack + attackerSupport ) * 2; i++) {
		if (arc4random() % (defendingPiece.defense + defenderSupport + defenderTerrainDefense) == 0) {
			attackerDoesDamage++;
		}
	}

	int defenderDoesDamage = 0;
	for (int i = 0; i < (defendingPiece.attack + defenderSupport) * 2; i++) {
		if (arc4random() % (selectedPiece.defense + attackerSupport + attackerTerrainDefense) == 0) {
			defenderDoesDamage++;
		}
	}

	[defendingPiece takeDamage:attackerDoesDamage];
	[selectedPiece takeDamage:defenderDoesDamage];

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The battle animation" message:[NSString stringWithFormat:@"Your support bonus: %i\nEnemy support bonus: %i\n\nYour terrain bonus: %i\nEnemy terrain bonus: %i\n\nYou do damage: %i\nEnemy does damage: %i", attackerSupport, defenderSupport, attackerTerrainDefense, defenderTerrainDefense, attackerDoesDamage, defenderDoesDamage] delegate:nil cancelButtonTitle:@"Bam" otherButtonTitles:nil];
	[alert show];
	[alert release];

	if (defendingPiece.hp <= 0) {
		[defendingPiece removeFromSuperlayer];
		[gameView.map removeGamePiece:defendingPiece];
	}

	if (selectedPiece.hp <= 0) {
		[selectedPiece removeFromSuperlayer];
		[gameView.map removeGamePiece:selectedPiece];
	}

	[selectedPiece afterAttack];
	gameState = waitingState;
	[self refreshView];
}

- (void)finishMove {
	[selectedPiece wasteMovement];
	gameState = waitingState;
	[self refreshView];
}

- (void)selectUsableUnit {
	GamePiece *piece = [gameView.map firstUsableUnit];
	if (piece) {
		gameState = unitSelectedState;
		selectedPiece = piece;
		[self refreshView];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No more units" message:@"All of your units have moved.  End your turn?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
		[alert show];
		[alert release];
	}
}

- (void)cancelAttack {
	gameState = unitSelectedState;
	[self refreshView];
}

// TODO: Reimplement hold fire button
- (void)skipAttack {
	gameState = waitingState;
	[self refreshView];
}

- (void)deselectPiece {
	selectedPiece = nil;
	gameState = waitingState;
	[self refreshView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) {
		Map *map = gameView.map;

		CGPoint tloc = [touch locationInView:map];
		CALayer *hex = [map hexFromPoint:tloc];
		if (hex) {
			GamePiece *piece = [map pieceFromPoint:tloc];

			switch (gameState) {
				default:
				case waitingState:
					if (piece && [piece canBeUsed] && piece.player == currentPlayerTurn) {
						gameState = unitSelectedState;
					}
					
					if (piece) {
						selectedPiece = piece;
					} else {
						selectedPiece = nil;
					}
					
					selectedHex = hex;
					break;

				case unitSelectedState:
					if (!piece) {
						if ([map pieceCanMoveToHex:hex piece:selectedPiece]) {
							[selectedPiece moveToHex:hex];
							selectedHex = hex;
							if (false == [selectedPiece canBeUsed]) {
								gameState = waitingState;
							}
						}
					} else if (piece.player == currentPlayerTurn) {
						selectedPiece = piece;
					} else if ([map pieceCanAttackDefender:piece attacker:selectedPiece]) {
						defendingPiece = piece;
						gameState = verifyAttackState;
					}					
					break;
					
				case verifyAttackState:
					if (piece == defendingPiece) {
						[self doAttack];
					}
					break;
			}
			[self refreshView];
		}
    }
}

- (void)refreshView {
	[gameView.map updateShades];
	[gameView updateActionButtonBoxWithState:gameState];
	[gameView updatePieceInfoWithPiece:selectedPiece];
	[gameView updateTerrainInfoWithHex:selectedHex];
}

@end