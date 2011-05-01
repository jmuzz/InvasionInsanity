#include <SFML/Graphics.hpp>

#include "GamePiece.hpp"

int main()
{
  sf::RenderWindow app(sf::VideoMode(800, 600, 32), "SFML Window");

  sf::Image hexImage;
  if (!hexImage.LoadFromFile("gfx/hex.png"))
  {
    app.Close();
  }

  sf::Sprite hexSprite[10][10];
  for (int i = 0; i < 10; i++)
  {
    for (int j = 0; j < 10; j++)
    {
      hexSprite[i][j].SetImage(hexImage);
      hexSprite[i][j].SetPosition(i*47, j*56);
      if (i % 2 == 1)
      {
        hexSprite[i][j].Move(0, 28);
      }
    }
  }

  GamePiece *piece[6];
  piece[0] = new GamePiece(0, 0, 0);

  for (int i = 0; i < 6; i++)
  {
    piece[i] = new GamePiece(i, i*2, 0);
  }

  while (app.IsOpened())
  {
    sf::Event Event;
    while (app.GetEvent(Event))
    {
      if (Event.Type == sf::Event::Closed)
        app.Close();
    }

    app.Clear(sf::Color(255, 255, 255));
    for (int i = 0; i < 10; i++)
    {
      for (int j = 0; j < 10; j++)
      {
        app.Draw(hexSprite[i][j]);
      }
    }

    for (int i = 0; i < 6; i++) {
      app.Draw(*piece[i]);
    }

    app.Display();
  }

  return EXIT_SUCCESS;
}
