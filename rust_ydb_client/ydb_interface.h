#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct CPointer_Mutex_Arc_CallState_Client CPointer_Mutex_Arc_CallState_Client;

typedef struct YdbConnection {
  struct CPointer_Mutex_Arc_CallState_Client client;
} YdbConnection;

#ifdef __cplusplus
extern "C" {
#endif // __cplusplus

int ydb_check_linked_library(void);

struct YdbConnection *ydb_connect(const char *connection_string);

int ydb_connect_has_result(const struct YdbConnection *ydb_connection);

int ydb_connect_wait(const struct YdbConnection *ydb_connection);

void ydb_connect_free(struct YdbConnection *ydb_connection);

#ifdef __cplusplus
} // extern "C"
#endif // __cplusplus
