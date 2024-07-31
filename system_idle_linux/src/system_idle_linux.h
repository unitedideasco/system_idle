#ifndef SYSTEM_IDLE_FFI_API_H_
#define SYSTEM_IDLE_FFI_API_H_

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct NativePlugin NativePlugin;

NativePlugin* createPlugin();
void freePlugin(NativePlugin* ptr);

void initPlugin(NativePlugin* ptr);
uint32_t getIdleTime(NativePlugin* ptr);

#ifdef __cplusplus
}
#endif

#endif
