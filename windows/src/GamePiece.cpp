#include <SFML/Graphics.hpp>

#include "GamePiece.hpp"

void gamePieceInit()
{
  if (!gamePieceImage.LoadFromFile("gfx/sprites.png"))
  {
    // TODO Add error reporting
  }
  gamePieceInitRan = true;
}

GamePiece::GamePiece(int type, int gameX, int gameY)
{
  if (false == gamePieceInitRan)
  {
    gamePieceInit();
  }

  this->SetImage(gamePieceImage);
  this->SetSubRect(sf::IntRect(
        gamePiecePokeCoords[type][0]*80,
        gamePiecePokeCoords[type][1]*80,
        (gamePiecePokeCoords[type][0]+1) * 80,
        (gamePiecePokeCoords[type][1]+1) * 80)
  );
  this->Resize(48, 48);
  this->setPosition(gameX, gameY);
}

void GamePiece::setPosition(int gameX, int gameY)
{
  gameX_ = gameX;
  gameY_ = gameY;
  this->SetPosition(gameX * 47, gameY * 56);
  if (gameY % 2 == 1)
  {
    this->Move(0, 29);
  }
  this->Move(9, 9);
}
