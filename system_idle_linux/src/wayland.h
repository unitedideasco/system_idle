#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct WaylandPlugin WaylandPlugin;
typedef void (*IdleCallback)(bool isIdle);

WaylandPlugin* createPlugin();
void freePlugin(WaylandPlugin* plugin);

bool initPlugin(WaylandPlugin* plugin, IdleCallback callback);
bool listenForIdleEvents(WaylandPlugin* plugin, int duration_ms);
void pollEvents(WaylandPlugin* plugin);

#ifdef __cplusplus
}
#endif
