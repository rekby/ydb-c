cdef extern from "ydb_interface.h":
    struct YdbConnection:
        pass
    struct YdbResult:
        pass

    YdbConnection* ydb_connect(char *connectionString)
    void ydb_connect_free(YdbConnection* connection)

