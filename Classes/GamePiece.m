#import "GamePiece.h"
#import "Map.h"

@implementation GamePiece

static CGImageRef pieceImageRefs[2][NUM_PIECE_TYPES];
static bool initialized = false;

typedef struct {
	int hp, attack, defense, movement, minRange, maxRange;
	NSString *title;
} unitType;

static const unitType unitTypes[3] = {
	{8, 10, 8, 5, 1, 1, @"Pawn"},
	{6, 8, 6, 3, 2, 3, @"Archer"},
	{14, 10, 7, 4, 1, 1, @"Hero"}
};

@synthesize map, x, y, hp, attack, defense, movement, title, player, moved, minRange, maxRange;

- (id)initWithPieceType:(int)type player:(int)ownedByPlayer {
	if (self = [super init]) {
		if (false == initialized) {
			UIImage *pieceImages = [UIImage imageNamed:@"pieces.png"];
			CGImageRef ir = CGImageCreateCopy([pieceImages CGImage]);
			for (int i = 0; i < 2; i++) {
				for (int j = 0; j < NUM_PIECE_TYPES; j++) {
					pieceImageRefs[i][j] = CGImageCreateWithImageInRect(ir, CGRectMake(j*36, i*32, 36, 32));
				}
			}
			CGImageRelease(ir);
			[pieceImages release];
			initialized = true;
		}

		moved    = false;
		player   = ownedByPlayer;
		hp       = unitTypes[type].hp;
		attack   = unitTypes[type].attack;
		movement = unitTypes[type].movement;
		title    = unitTypes[type].title;
		minRange = unitTypes[type].minRange;
		maxRange = unitTypes[type].maxRange;
		defense  = unitTypes[type].defense;
		
		hpChangeAnimation = [CALayer layer];
		hpChangeAnimation.anchorPoint = CGPointMake(0.0f, 0.0f);
		hpChangeAnimation.bounds = CGRectMake(0.0f, 0.0f, 36.0f, 32.0f);
		hpChangeAnimation.zPosition = 40.0f;
		
		CALayer *hpChangeMask = [CALayer layer];
		hpChangeMask.anchorPoint = CGPointMake(0.0f, 0.0f);
		hpChangeMask.bounds = CGRectMake(0.0f, 0.0f, 36.0f, 32.0f);
		//hpChangeMask.contents = [???];

		self.bounds = CGRectMake(0.0f, 0.0f, 36.0f, 32.0f);
		self.contents = pieceImageRefs[player][type];
	}
	return self;
}

- (void)takeDamage:(int) damage {
	hp -= damage;
}

- (void)setCoordsToX:(int)newX y:(int)newY {
	CGPoint location = [map locationOfHexAtX:newX y:newY];
	self.position = location;
	x = newX;
	y = newY;
}

- (void)dealloc {
	[title dealloc];
    [super dealloc];
}
	
@end
