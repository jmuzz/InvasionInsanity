#import "GameView.h"
#import "GameViewController.h"
#import "Map.h"
#import "GamePiece.h"

@implementation GameView

@synthesize gameViewController, map;

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		// Create map
		CGRect mapFrame = CGRectMake(0, 0, CGRectGetWidth([self frame]), CGRectGetHeight([self frame]) - 88);
		map = [[Map alloc] initWithFrame:mapFrame];

		// Create terrain info bar
		terrainInfoBar = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(mapFrame) + 48, CGRectGetWidth(mapFrame) - 120, 32)];
		selectedTerrainPicture = [CALayer layer];
		selectedTerrainPicture.anchorPoint = CGPointMake(0.0f, 0.0f);
		selectedTerrainPicture.position = CGPointMake(10.0f, 0.0f);
		selectedTerrainPicture.bounds = CGRectMake(0.0f, 0.0f, 36.0f, 32.0f);
		[[terrainInfoBar layer] addSublayer:selectedTerrainPicture];
		terrainInfoText = [[UILabel alloc] initWithFrame:CGRectMake(56, 0, CGRectGetWidth(mapFrame) - 176, 32)];
		terrainInfoText.font = [UIFont systemFontOfSize:12.0f];
		terrainInfoText.numberOfLines = 2;
		[terrainInfoBar addSubview:terrainInfoText];

		// Create game piece info par
		pieceInfoBar = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(mapFrame) + 8, CGRectGetWidth(mapFrame) - 120, 32)];
		selectedPiecePicture = [CALayer layer];
		selectedPiecePicture.anchorPoint = CGPointMake(0.0f, 0.0f);
		selectedPiecePicture.position = CGPointMake(10.0f, 0.0f);
		selectedPiecePicture.bounds = CGRectMake(0.0f, 0.0f, 36.0f, 32.0f);
		[[pieceInfoBar layer] addSublayer:selectedPiecePicture];
		pieceInfoText = [[UILabel alloc] initWithFrame:CGRectMake(56, 0, CGRectGetWidth(mapFrame) - 176, 32)];
		pieceInfoText.font = [UIFont systemFontOfSize:12.0f];
		pieceInfoText.numberOfLines = 2;
		[pieceInfoBar addSubview:pieceInfoText];

		// Create action button box
		actionButtonBox = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(mapFrame) - 112, CGRectGetHeight(mapFrame) + 8, 112, 60)];
		for (int i = 0; i < NUM_ACTION_BUTTONS; i++) {
			actionButtons[i] = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		}
		
		[actionButtons[0] setTitle:@"End Move" forState:UIControlStateNormal];
		[actionButtons[0] addTarget:gameViewController action:@selector(finishMove) forControlEvents:UIControlEventTouchUpInside];
		actionButtons[0].frame = CGRectMake(0, 0, 102, 16);
		
		[actionButtons[1] setTitle:@"Deselect" forState:UIControlStateNormal];
		[actionButtons[1] addTarget:gameViewController action:@selector(deselectPiece) forControlEvents:UIControlEventTouchUpInside];
		actionButtons[1].frame = CGRectMake(0, 24, 102, 16);
		
		[actionButtons[2] setTitle:@"Usable Unit" forState:UIControlStateNormal];
		[actionButtons[2] addTarget:gameViewController action:@selector(selectUsableUnit) forControlEvents:UIControlEventTouchUpInside];
		actionButtons[2].frame = CGRectMake(0, 0, 102, 16);
		
		[actionButtons[3] setTitle:@"End Turn" forState:UIControlStateNormal];
		[actionButtons[3] addTarget:gameViewController action:@selector(endTurn) forControlEvents:UIControlEventTouchUpInside];
		actionButtons[3].frame = CGRectMake(0, 24, 102, 16);
		
		[actionButtons[4] setTitle:@"Back" forState:UIControlStateNormal];
		[actionButtons[4] addTarget:gameViewController action:@selector(cancelAttack) forControlEvents:UIControlEventTouchUpInside];
		actionButtons[4].frame = CGRectMake(0, 48, 102, 16);
		
		[actionButtons[5] setTitle:@"Attack" forState:UIControlStateNormal];
		[actionButtons[5] addTarget:gameViewController action:@selector(doAttack) forControlEvents:UIControlEventTouchUpInside];
		actionButtons[5].frame = CGRectMake(0, 24, 102, 16);
		
		[actionButtons[6] setTitle:@"Hold Fire" forState:UIControlStateNormal];
		[actionButtons[6] addTarget:gameViewController action:@selector(skipAttack) forControlEvents:UIControlEventTouchUpInside];
		actionButtons[6].frame = CGRectMake(0, 0, 102, 16);
		
		[actionButtons[7] setTitle:@"Undo" forState:UIControlStateNormal];
		[actionButtons[7] addTarget:gameViewController action:@selector(undoMove) forControlEvents:UIControlEventTouchUpInside];
		actionButtons[7].frame = CGRectMake(0, 48, 102, 16);
		
		[self updateActionButtonBoxWithState:waitingState];

		[self addSubview:actionButtonBox];
		[self addSubview:terrainInfoBar];
		[self addSubview:pieceInfoBar];
		[self addSubview:map];
	}
	return self;
}

- (void)updatePieceInfoWithPiece:(GamePiece *)piece {
	selectedPiecePicture.contents = [piece contents];
	if (piece) {
		pieceInfoText.text = [NSString stringWithFormat:@"%@\nHP:%i Att:%i Mv:%i/%i Def:%i", piece.title, piece.hp, piece.attack, piece.curMovement, piece.maxMovement, piece.defense];
	} else {
		pieceInfoText.text = @"No unit";
	}
}

- (void)updateTerrainInfoWithHex:(CALayer *)hex {
	selectedTerrainPicture.contents = [hex contents];
	TerrainType terrainType = [map typeOfHex:hex];
	terrainInfoText.text = [NSString stringWithFormat:@"%@\nMv:%i Def:%i", terrainType.name, terrainType.movementCost, terrainType.defenseBonus];
}

- (void)updateActionButtonBoxWithState:(int)state {
	for (int i = 0; i < NUM_ACTION_BUTTONS; i++) {
		[actionButtons[i] removeFromSuperview];
	}

	GamePiece *piece = gameViewController.selectedPiece;
	switch (state) {
		case (unitSelectedState):
			if (piece.curMovement == 0 && [piece canAttack]) {
				[actionButtonBox addSubview:actionButtons[6]];
			} else if (piece.curMovement > 0) {
				[actionButtonBox addSubview:actionButtons[0]];
			}
			if (piece.canUndo) {
				[actionButtonBox addSubview:actionButtons[7]];
			}
			[actionButtonBox addSubview:actionButtons[1]];
			break;

		case (waitingState):
			[actionButtonBox addSubview:actionButtons[2]];
			[actionButtonBox addSubview:actionButtons[3]];
			break;
			
		case (verifyAttackState):
			[actionButtonBox addSubview:actionButtons[4]];
			[actionButtonBox addSubview:actionButtons[5]];
			break;
	}
}

- (void)dealloc {
	[map release];
	[terrainInfoBar release];
	[super dealloc];
}

@end