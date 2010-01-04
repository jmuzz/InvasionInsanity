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
			actionButtons[i].frame = CGRectMake(0, i*24, 102, 16);
		}

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
		pieceInfoText.text = [NSString stringWithFormat:@"%@\nHP:%i Att:%i Mv:%i", piece.name, piece.hp, piece.attack, piece.movement];
	} else {
		pieceInfoText.text = @"No unit";
	}
}

- (void)updateTerrainInfoWithHex:(CALayer *)hex {
	selectedTerrainPicture.contents = [hex contents];
	switch ([[hex valueForKey:@"terrainType"] intValue]) {
		case 0:
			terrainInfoText.text = @"Water";
			break;
			
		case 1:
			terrainInfoText.text = @"Road";
			break;
			
		case 2:
			terrainInfoText.text = @"Grass";
			break;
			
		default:
			terrainInfoText.text = @"";
			break;
	}
}

- (void)updateActionButtonBoxWithState:(int)state {
	for (int i = 0; i < NUM_ACTION_BUTTONS; i++) {
		[actionButtons[i] removeFromSuperview];
		[actionButtons[i] removeTarget:gameViewController action:NULL forControlEvents:UIControlEventTouchUpInside];
	}

	switch (state) {
		case (unitSelectedState):
			[actionButtons[0] setTitle:@"Stay Put" forState:UIControlStateNormal];
			actionButtons[0].enabled = false;
			[actionButtonBox addSubview:actionButtons[0]];
			
			[actionButtons[1] setTitle:@"Deselect" forState:UIControlStateNormal];
			[actionButtons[1] addTarget:gameViewController action:@selector(deselectPiece) forControlEvents:UIControlEventTouchUpInside];
			[actionButtonBox addSubview:actionButtons[1]];
			break;
	}
}

- (void)dealloc {
	[map release];
	[terrainInfoBar release];
	[super dealloc];
}

@end