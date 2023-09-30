typedef struct ConnectionHandler {
    int connection_id;
} ConnectionHandler;

extern int ydb_check_linked_library();

extern struct ConnectionHandler ydb_connect(char* connectionString, int connectionStringLen);
extern int ydb_connect_wait(struct ConnectionHandler connection);

