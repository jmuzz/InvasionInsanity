#include <SFML/Graphics.hpp>

int main()
{
  sf::RenderWindow App(sf::VideoMode(800, 600, 32), "SFML Window");
  sf::Image Image;
  if (!Image.LoadFromFile("sprite.png"))
  {
    App.Close();
  }
  sf::Sprite Sprite;
  Sprite.SetImage(Image);

  while (App.IsOpened())
  {
    sf::Event Event;
    while (App.GetEvent(Event))
    {
      if (Event.Type == sf::Event::Closed)
        App.Close();
    }

    App.Clear(sf::Color(200, 0, 0));
    App.Draw(Sprite);

    App.Display();
  }

  return EXIT_SUCCESS;
}
