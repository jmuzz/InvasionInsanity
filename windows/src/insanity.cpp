#include <SFML/Window.hpp>

int main()
{
  sf::Window App(sf::VideoMode(800, 600, 32), "SFML Window");
  App.Display();
  sf::Sleep(5.f);

  return EXIT_SUCCESS;
}
