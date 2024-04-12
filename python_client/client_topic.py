import time
import typing

import ydb  # needs to be installed from pypi version 3.x

from ctypes import *

connectionString = "grpc://localhost:2135/?database=local"


class CModConn:
    l: typing.Any
    connection: typing.Any
    mod: typing.Any
    reader: typing.Any

    _closed: bool

    def __init__(self):
        self._closed = False

        import sys
        from os.path import dirname, abspath
        libdir = dirname(dirname(abspath(__file__))) + "/go_for_python/_obj"
        print(libdir)
        sys.path.append(libdir)

        import go_for_python
        self.mod = go_for_python

    def connect(self):
            self.connection = self.mod.connect(connectionString)
            print(self.connection)

    def close(self):
        if self._closed:
            return

        self._closed = True

    def prepare(self):
         self.connect()
         self.reader = self.mod.start_reader(self.connection, "topic", "consumer")

    def test(self):
        print("start")
        count = 0
        start = time.monotonic()
        while True:
            res = self.mod.read_batch(self.reader)
            if res is None:
                break
            print("Messages len:", len(res["messages"]))
            print("message:", res["messages"][0])
            count += len(res["messages"])

        duration = time.monotonic() - start - 1
        return {
             "time": duration,
             "count": count,
        }


cMod = CModConn()
cMod.prepare()
print(cMod.test())
