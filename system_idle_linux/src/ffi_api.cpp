#include <xcb/xcb.h>
#include <xcb/screensaver.h>

#include "ffi_api.h"

struct NativePluginCpp {
  xcb_connection_t* connection;
  xcb_screen_t* screen;

  void init() {
    connection = xcb_connect(nullptr, nullptr);
    screen = xcb_setup_roots_iterator(xcb_get_setup(connection)).data;
  }
};

NativePlugin* createPlugin() {
  return reinterpret_cast<NativePlugin*>(new NativePluginCpp);
}

void freePlugin(NativePlugin* ptr) {
  delete reinterpret_cast<NativePluginCpp*>(ptr);
}

void initPlugin(NativePlugin* ptr) {
  auto plugin = reinterpret_cast<NativePluginCpp*>(ptr);
  plugin->init();
}

uint32_t getIdleTime(NativePlugin* ptr) {
  auto plugin = reinterpret_cast<NativePluginCpp*>(ptr);
  auto cookie = xcb_screensaver_query_info(plugin->connection, plugin->screen->root);
  auto response = xcb_screensaver_query_info_reply(plugin->connection, cookie, nullptr);
  if (response == nullptr) return 0;
  return response->ms_since_user_input;
}
