#import "GamePiece.h"
#import "Map.h"

@implementation GamePiece

static CGImageRef pieceImageRefs[2][NUM_PIECE_TYPES];
static bool initialized = false;

@synthesize map, x, y;

- (id)initWithPieceType:(int)type player:(int)player {
	if (self = [super init]) {
		if (false == initialized) {
			UIImage *pieceImages = [UIImage imageNamed:@"pieces.png"];
			CGImageRef ir = CGImageCreateCopy([pieceImages CGImage]);
			for (int i = 0; i < 2; i++) {
				for (int j = 0; j < NUM_PIECE_TYPES; j++) {
					pieceImageRefs[i][j] = CGImageCreateWithImageInRect(ir, CGRectMake(j*36, i*32, 36, 32));
				}
			}
			initialized = true;
		}

		self.bounds = CGRectMake(0.0f, 0.0f, 36.0f, 32.0f);
		self.contents = pieceImageRefs[player][type];
	}
	return self;
}

- (void)setCoordsToX:(int)new_x y:(int)new_y {
	CGPoint location = [map locationOfHexAtX:new_x y:new_y];
	self.position = location;
	x = new_x;
	y = new_y;
}

- (void)dealloc {
	[map release];
    [super dealloc];
}
	
@end
