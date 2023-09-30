typedef struct YdbConnection {} YdbConnection;
typedef struct YdbResult {} YdbResult;

extern struct YdbConnection* ydb_connect(char* connectionString, int connectionStringLen);
extern int ydb_connect_wait(struct YdbConnection* connection);
extern void ydb_connect_free(struct YdbConnection* connection);
extern struct YdbResult* ydb_query(struct YdbConnection* connection, char* query, int queryLen);
extern void ydb_result_free(struct YdbResult* res);
extern void ydb_result_wait(struct YdbResult* res);
extern int ydb_result_has_errors(struct YdbResult* res);
extern int ydb_result_next_readset(struct YdbResult* res);
extern int ydb_result_next_row(struct YdbResult* res);
extern int ydb_result_read_first_field_text(struct YdbResult* res, void* dstBuffer, int dstBufferLen);
extern int ydb_check_linked_library();
