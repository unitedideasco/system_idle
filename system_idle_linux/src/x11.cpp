#include <xcb/xcb.h>
#include <xcb/screensaver.h>

#include "x11.h"

struct X11Plugin {
  xcb_connection_t* connection;
  xcb_screen_t* screen;
};

X11Plugin* createPlugin() {
  return new X11Plugin();
}

void freePlugin(X11Plugin* plugin) {
  if (plugin->connection != nullptr) xcb_disconnect(plugin->connection);
  delete plugin->screen;
  delete plugin;
}

bool initPlugin(X11Plugin* plugin) {
  plugin->connection = xcb_connect(nullptr, nullptr);
  plugin->screen = xcb_setup_roots_iterator(xcb_get_setup(plugin->connection)).data;
  return plugin->connection != nullptr && plugin->screen != nullptr;
}

uint32_t getIdleTime(X11Plugin* plugin) {
  auto request = xcb_screensaver_query_info(plugin->connection, plugin->screen->root);
  auto response = xcb_screensaver_query_info_reply(plugin->connection, request, nullptr);
  if (response == nullptr) return 0;
  return response->ms_since_user_input;
}
