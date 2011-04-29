#include <SFML/Graphics.hpp>

int main()
{
  sf::RenderWindow app(sf::VideoMode(800, 600, 32), "SFML Window");
  sf::Image hexImage;
  if (!hexImage.LoadFromFile("gfx/hex.png"))
  {
    app.Close();
  }
  sf::Sprite hexSprite;
  hexSprite.SetImage(hexImage);

  while (app.IsOpened())
  {
    sf::Event Event;
    while (app.GetEvent(Event))
    {
      if (Event.Type == sf::Event::Closed)
        app.Close();
    }

    app.Clear(sf::Color(255, 255, 255));
    app.Draw(hexSprite);

    app.Display();
  }

  return EXIT_SUCCESS;
}
