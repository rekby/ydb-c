package main

import (
	"fmt"
	"unsafe"
)

// TODO: detect and set lib name by auto to LDFLAGS
// install pkg-config

// #cgo pkg-config: python3
// #cgo LDFLAGS: -lpython3.12
// #include "c_bind_python.h"
import "C"

///
/// Python module
///

//export ydb_python_read_result
func ydb_python_read_result(self *C.PyObject, args *C.PyObject) *C.PyObject {
	fmt.Println("!!!")
	cRes := C.CString("test")
	res := C.PyLong_FromLong(123)
	C.free(unsafe.Pointer(cRes))
	return res
}