#include <SFML/Graphics.hpp>

int main()
{
  sf::RenderWindow app(sf::VideoMode(800, 600, 32), "SFML Window");

  sf::Image hexImage;
  if (!hexImage.LoadFromFile("gfx/hex.png"))
  {
    app.Close();
  }

  sf::Image spriteImage;
  if (!spriteImage.LoadFromFile("gfx/sprites.png"))
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

  sf::Sprite sprite[6];
  int pokecoords[6][2] = {
    {12, 1},
    {8, 2},
    {2, 3},
    {23, 9},
    {9, 12},
    {9, 17}
  };
  for (int i = 0; i < 6; i++)
  {
    sprite[i].SetImage(spriteImage);
    sprite[i].SetSubRect(sf::IntRect(pokecoords[i][0]*80, pokecoords[i][1]*80, (pokecoords[i][0]+1) * 80, (pokecoords[i][1]+1) * 80));
    sprite[i].Resize(48, 48);
    sprite[i].SetPosition(i * 47 * 2, 0);
    sprite[i].Move(9, 9);
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
      app.Draw(sprite[i]);
    }

    app.Display();
  }

  return EXIT_SUCCESS;
}
