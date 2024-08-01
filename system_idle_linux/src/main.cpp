#include <iostream>

#include "wayland.h"

void onIdle(bool isIdle) {
  std::cout << "Is idle? " << isIdle << std::endl;
}

int main() {
  std::cout << "Creating..." << std::endl;
  auto plugin = createPlugin();
  std::cout << "Initting..." << std::endl;
  initPlugin(plugin, onIdle);
  std::cout << "Polling..." << std::endl;
  pollEvents(plugin);
  std::cout << "Freeing..." << std::endl;
  freePlugin(plugin);
  std::cout << "Done!" << std::endl;
}