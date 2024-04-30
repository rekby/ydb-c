from . cimport ydb_c
from cpython cimport bool

cdef class Connection:
    cdef ydb_c.YdbConnection* _connection
    cdef bool _closed

    def __init__(self):
        raise TypeError('Cannot create instance from Python')

    @staticmethod
    cdef Connection create(ydb_c.YdbConnection* connection_handler):
        res = <Connection>Connection.__new__(Connection) # create instance without call __init__
        res._closed = False
        res._connection = connection_handler
        print("inited {0:x}", <unsigned long> res._connection)
        return res

    def close(self):
        if self._closed:
            return

        self._closed = True
        print("closing {0:x}", <unsigned long> self._connection)
        ydb_c.ydb_connect_free(self._connection)

    def __del__(self):
        self.close()


def open(str connection_string) -> Connection:
    connection_string_bytes = connection_string.encode()
    cdef char *connection_string_bytes_pointer = connection_string_bytes
    connection_handler = ydb_c.ydb_connect(connection_string_bytes_pointer)
    return Connection.create(connection_handler)
