#import "GameViewController.h"
#import "GameView.h"
#import "Map.h"
#import "GamePiece.h"

@implementation GameViewController

@synthesize gameView, delegate, currentPlayerTurn, gameState, selectedPiece, defendingPiece, selectedHex;

- (void) loadView {
	self.wantsFullScreenLayout = YES;
}

- (void)resetGameWithMap:(int)mapChoice {
	GameView *view = [[GameView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame mapChoice:mapChoice];
	view.gameViewController = self;
	self.view = view;
	self.gameView = view;
	gameState = waitingState;
	currentPlayerTurn = 0;
	view.map.gameViewController = self;
	selectedHex = [gameView.map hexAtLocationX:5 y:5];
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
	
	// Ranged attacks do not use support
	if (selectedPiece.minRange > 1) {
		attackerSupport = defenderSupport = 0;
	}
	
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
	
	// Ranged attacks cannot be retaliated
	if (selectedPiece.minRange > 1) {
		defenderDoesDamage = 0;
	}

	[defendingPiece takeDamage:attackerDoesDamage];
	[selectedPiece takeDamage:defenderDoesDamage];

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The battle animation" message:[NSString stringWithFormat:@"Your support bonus: %i\nEnemy support bonus: %i\n\nYour terrain bonus: %i\nEnemy terrain bonus: %i\n\nYou do damage: %i\nEnemy does damage: %i", attackerSupport, defenderSupport, attackerTerrainDefense, defenderTerrainDefense, attackerDoesDamage, defenderDoesDamage] delegate:nil cancelButtonTitle:@"Bam" otherButtonTitles:nil];
	[alert show];
	[alert release];
	
	[map clearUndo];

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

- (void)skipAttack {
	gameState = waitingState;
	[selectedPiece afterAttack];
	[self refreshView];
}

- (void)undoMove {
	[selectedPiece undo];
	[self refreshView];
}

- (void)deselectPiece {
	selectedPiece = nil;
	gameState = waitingState;
	[self refreshView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	Map *map = gameView.map;
	mapTouchLocation = [touch locationInView:map];
	viewTouchDownLocation = [touch locationInView:gameView];
	scrolledThisTouch = false;
	if (viewTouchDownLocation.x > CGRectGetWidth(map.frame) || viewTouchDownLocation.y > CGRectGetHeight(map.frame)) {
		mapTouchLocation = CGPointMake(-1, -1);
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	Map *map = gameView.map;
	if (mapTouchLocation.x >= 0) {
		UITouch *touch = [touches anyObject];
		CGPoint viewTouchLocation = [touch locationInView:gameView];
		if (abs(viewTouchLocation.x - viewTouchDownLocation.x) > 10 || abs(viewTouchLocation.y - viewTouchDownLocation.y) > 10) {
			scrolledThisTouch = true;
		}
		map.bounds = CGRectMake(mapTouchLocation.x - viewTouchLocation.x, mapTouchLocation.y - viewTouchLocation.y, CGRectGetWidth(map.bounds), CGRectGetHeight(map.bounds));
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) {
		Map *map = gameView.map;

		CGPoint tloc = [touch locationInView:map];
		CGPoint gloc = [touch locationInView:gameView];
		CALayer *hex = [map hexFromPoint:tloc];
		if (hex) {
			GamePiece *piece = [map pieceFromPoint:tloc];

			switch (gameState) {
				default:
				case waitingState:
					if (piece && [piece canBeSelected] && piece.player == currentPlayerTurn) {
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
					} else if ([piece canBeSelected] && piece.player == currentPlayerTurn) {
						selectedPiece = piece;
					} else if ([map pieceCanAttackDefender:piece attacker:selectedPiece]) {
						defendingPiece = piece;
						gameState = verifyAttackState;
					}					
					break;
					
				case verifyAttackState:
					if (piece == defendingPiece) {
						[self doAttack];
					} else if ([piece canBeSelected] && piece.player == currentPlayerTurn) {
						selectedPiece = piece;
						gameState = unitSelectedState;
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