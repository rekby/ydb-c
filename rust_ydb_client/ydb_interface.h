#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct CPointer_Mutex_Client CPointer_Mutex_Client;

typedef struct YdbConnection {
  struct CPointer_Mutex_Client driver;
} YdbConnection;

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

int ydb_check_linked_library(void);

struct YdbConnection *ydb_connect(void);

#ifdef __cplusplus
} // extern "C"
#endif // __cplusplus
