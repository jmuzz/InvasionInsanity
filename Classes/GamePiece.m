#import "GamePiece.h"
#import "Map.h"

@implementation GamePiece

@synthesize map;

- (id)initWithPieceType:(int)type {
	if (self = [super init]) {
		UIImage *pieceImages = [UIImage imageNamed:@"pieces.png"];
	}
	return self;
}

- (void)dealloc {
	[map release];
    [super dealloc];
}
	
@end
