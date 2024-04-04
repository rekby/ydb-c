import time
import typing

import ydb  # needs to be installed from pypi version 3.x

from ctypes import *

connectionString = "grpc://localhost:2136/?database=local"


class CTypesConn:
    l: typing.Any
    handler: typing.Any

    _closed: bool

    def __init__(self):
        self._closed = False

        self.lib = CDLL("../go/_obj/libydb.so")
        # self.lib = CDLL("../rust_ydb_client/target/release/librust_ydb_client.dylib")
        lib = self.lib
        lib.ydb_connect.argtypes = [c_char_p]
        lib.ydb_connect.restype = c_void_p
        lib.ydb_connect_wait.argtypes = [c_void_p]
        lib.ydb_connect_wait.restype = c_int
        lib.ydb_connect_free.argtypes = [c_void_p]
        lib.ydb_connect_free.restype = None
        lib.ydb_query.argtypes = [c_void_p, c_char_p]
        lib.ydb_query.restype = c_void_p
        lib.ydb_result_free.argtypes = [c_void_p]
        lib.ydb_result_free.restype = None
        lib.ydb_result_wait.argtypes = [c_void_p]
        lib.ydb_result_wait.restype = None
        lib.ydb_result_next_readset.argtypes = [c_void_p]
        lib.ydb_result_next_readset.restype = c_int
        lib.ydb_result_next_row.argtypes = [c_void_p]
        lib.ydb_result_next_row.restype = c_int
        lib.ydb_result_read_first_field_text.argtypes = [c_void_p, c_void_p, c_int]

    def connect(self):
            conn_string_c = c_char_p(bytes(connectionString.encode()))
            self.handler = self.lib.ydb_connect(conn_string_c)
            print(self.handler)
            print(self.lib.ydb_connect_wait(self.handler))

    def close(self):
        if self._closed:
            return

        self._closed = True
        self.lib.ydb_connect_free(self.handler)

    def __del__(self):
        self.close()

    def query(self, query: str):
        lib = self.lib
        res = lib.ydb_query(self.handler, c_char_p(query.encode()))
        lib.ydb_result_wait(res)

        rs = []
        while lib.ydb_result_next_readset(res) == 0:
            result_set = []

            while lib.ydb_result_next_row(res) == 0:
                row = {}

                bufLen = 100
                c_res = create_string_buffer(b'\000', bufLen)
                lib.ydb_result_read_first_field_text(res, c_res, bufLen)
                field = c_res.value.decode()
                row["first"] = field
                result_set.append(row)
            rs.append(result_set)

        lib.ydb_result_free(res)
        return rs

class PyModConn:
    l: typing.Any

    def __init__(self):
        pass


def benchmark():
    conn = CTypesConn()
    conn.connect()

    driver = ydb.Driver(connection_string=connectionString)
    driver.wait()

    query = "SELECT 'asd' as col"
    conn.query(query)

    session = driver.table_client.session().create()

    with session.transaction() as tx:
        res = tx.execute(query, commit_tx=True)
        res = res[0]
        print(res.rows[0])


    iterations = 100

    start = time.monotonic()
    for i in range(iterations):
        conn.query(query)
    finish = time.monotonic()
    print()
    print("c interface")
    print(finish-start)

    start = time.monotonic()
    for i in range(iterations):
        with session.transaction() as tx:
            res = tx.execute(query, commit_tx=True)
    finish = time.monotonic()
    print()
    print("python driver interface")
    print(finish-start)


def import_lib(filepath: str):
    global __bootstrap__, __loader__, __file__
    import sys, pkg_resources, imp
    __file__ = pkg_resources.resource_filename(__name__,filepath)
    __loader__ = None; del __bootstrap__, __loader__
    imp.load_dynamic(__name__,__file__)


# import_lib("../go_for_python/_obj/go_for_python.so")

import sys
sys.path.append("../go_for_python/_obj")

import go_for_python

print(go_for_python)

print(go_for_python.ydb_python_read_result)

