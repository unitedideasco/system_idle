#include <stdbool.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct X11Plugin X11Plugin;

X11Plugin* createPlugin();
void freePlugin(X11Plugin* ptr);

bool initPlugin(X11Plugin* ptr);
uint32_t getIdleTime(X11Plugin* ptr);

#ifdef __cplusplus
}
#endif
