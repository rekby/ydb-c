cdef extern from "ydb_interface.h":
    struct YdbConnection:
        pass

    struct YdbResult:
        pass

    YdbConnection* ydb_connect(char *connectionString)
    int ydb_connect_wait(YdbConnection* connection);
    void ydb_connect_free(YdbConnection* connection)

    YdbResult* ydb_query(YdbConnection* connection, char* query)
    void ydb_result_wait(YdbResult* res)
    int ydb_result_has_errors(YdbResult* res)
    int ydb_result_next_readset(YdbResult* res)
    int ydb_result_next_row(YdbResult* res)
    int ydb_result_read_first_field_text(YdbResult* res, void* dstBuffer, int dstBufferLen)
    void ydb_result_free(YdbResult* res)
