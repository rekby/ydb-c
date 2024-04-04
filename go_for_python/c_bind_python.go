package main

import (
	"unsafe"
)

// TODO: detect and set lib name by auto to LDFLAGS
// install pkg-config

// #cgo pkg-config: python-3.10
// #cgo LDFLAGS: -lpython3.10
// #include "c_bind_python.h"
import "C"

///
/// Python module
///

//export ydb_python_read_result
func ydb_python_read_result(self *C.PyObject, args *C.PyObject) *C.PyObject {
	cRes := C.CString("test")
	res := C.PyUnicode_FromString(cRes)
	C.free(unsafe.Pointer(cRes))
	return res
}
