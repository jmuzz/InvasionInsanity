#ifndef GAMEPIECE_H
#define GAMEPIECE_H

class sf::Image;
class sf::Sprite;

static bool gamePieceInitRan = false;
static sf::Image gamePieceImage;

// Which pics to pull out of the spritesheet.  This will change as
// I don't plane to use pokemon graphics forever.
static int gamePiecePokeCoords[6][2] = {
  {12, 1},
  {8, 2},
  {2, 3},
  {23, 9},
  {9, 12},
  {9, 17}
};

class GamePiece : public sf::Sprite {
  public:
    GamePiece(int type, int gameX, int gameY);

  private:
    int gameX_;
    int gameY_;
};

#endif
