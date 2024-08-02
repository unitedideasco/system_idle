#include <wayland-client-protocol.h>
#include <wayland-server-core.h>
#include "wayland-ext_idle_notify_v1.h"

#include <cstring>
#include <iostream>
#include <unistd.h>

#include "wayland.h"

wl_registry_listener globalListener;
int display_event(int fd, uint32_t mask, void *data);
void handleGlobal(void *data, struct wl_registry *registry, uint32_t name, const char *interface, uint32_t version);
void handleGlobalRemove(void *data, struct wl_registry *registry, uint32_t name);


class WaylandPlugin {
  public:
  wl_display* display;
  wl_registry* registry;
  wl_seat* seat;
  ext_idle_notifier_v1* notifier;
  ext_idle_notification_v1* notification;
  wl_event_loop* eventLoop;
  wl_event_source* eventSource;

  ~WaylandPlugin() {
    if (eventSource != nullptr) wl_event_source_remove(eventSource);
    if (notification != nullptr) ext_idle_notification_v1_destroy(notification);
    if (notifier != nullptr) ext_idle_notifier_v1_destroy(notifier);
    if (eventLoop != nullptr) wl_event_loop_destroy(eventLoop);
    if (seat != nullptr) wl_seat_destroy(seat);
    if (registry != nullptr) wl_registry_destroy(registry);
    if (display != nullptr) wl_display_disconnect(display);
  }

  bool init() {
    eventLoop = wl_event_loop_create();
    display = wl_display_connect(nullptr);
    if (display == nullptr) return false;
    registry = wl_display_get_registry(display);
    if (registry == nullptr) return false;
    wl_registry_add_listener(registry, &globalListener, nullptr);
    wl_display_roundtrip(display);
    auto source = wl_event_loop_add_fd(
      eventLoop,
      wl_display_get_fd(display),
      WL_EVENT_READABLE,
      display_event,
      nullptr
    );
    wl_event_source_check(source);
    return notifier != nullptr && seat != nullptr;
  }
};

IdleCallback idleCallback;
WaylandPlugin* globalPlugin;

void handle_idled(void *data, struct ext_idle_notification_v1 *notif) {
  if (idleCallback == nullptr) return;
  idleCallback(true);
}

void handle_resumed(void *data, struct ext_idle_notification_v1 *notif) {
  if (idleCallback == nullptr) return;
  idleCallback(false);
}

ext_idle_notification_v1_listener idleListener = {
	.idled = handle_idled,
	.resumed = handle_resumed,
};

WaylandPlugin* createPlugin() {
  return new WaylandPlugin();
}

void freePlugin(WaylandPlugin* plugin) {
  delete plugin;
}

bool initPlugin(WaylandPlugin* plugin, IdleCallback callback) {
  globalListener = {
    .global = handleGlobal,
    .global_remove = handleGlobalRemove,
  };
  globalPlugin = plugin;
  idleCallback = callback;
  return plugin->init();
}

void pollEvents(WaylandPlugin* plugin) {
  wl_event_loop_dispatch(plugin->eventLoop, 0);
}

bool listenForIdleEvents(WaylandPlugin* plugin, int duration_ms) {
  auto notifier = plugin->notifier;
  uint32_t timeout = duration_ms;
  if (notifier == nullptr || plugin->seat == nullptr) return false;
  if (plugin->notification != nullptr) ext_idle_notification_v1_destroy(plugin->notification);
  plugin->notification = ext_idle_notifier_v1_get_idle_notification(notifier, timeout, plugin->seat);
  ext_idle_notification_v1_add_listener(plugin->notification, &idleListener, nullptr);
  return true;
}

bool checkInterfaces(const char* a, const wl_interface& b) {
  return strcmp(a, b.name) == 0;
}

void handleGlobal(
  void *data,
  struct wl_registry *registry,
  uint32_t name,
  const char *interface,
  uint32_t version
) {
  if (globalPlugin == nullptr) return;
  if (checkInterfaces(interface, ext_idle_notifier_v1_interface)) {
    globalPlugin->notifier = (ext_idle_notifier_v1*) wl_registry_bind(registry, name, &ext_idle_notifier_v1_interface, 1);
  } else if (checkInterfaces(interface, wl_seat_interface)) {
    globalPlugin->seat = (wl_seat*) wl_registry_bind(registry, name, &wl_seat_interface, 2);
  }
}

void handleGlobalRemove(void *data, struct wl_registry *registry, uint32_t name) { }

int display_event(int fd, uint32_t mask, void *data) {
	if ((mask & WL_EVENT_HANGUP) || (mask & WL_EVENT_ERROR)) {
    exit(1);
	}
  auto display = globalPlugin->display;

	int count = 0;
	if (mask & WL_EVENT_READABLE) {
		count = wl_display_dispatch(display);
	}
	if (mask & WL_EVENT_WRITABLE) {
		wl_display_flush(display);
	}
	if (mask == 0) {
		count = wl_display_dispatch_pending(display);
		wl_display_flush(display);
	}

	if (count < 0) {
    exit(1);
	}

	return count;
}
