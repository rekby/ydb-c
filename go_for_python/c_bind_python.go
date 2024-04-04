package main

import (
	"runtime"
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
	return toPyString("haha")
}

func toPyString(s string) *C.PyObject {
	sLen := len(s)
	if sLen == 0 {
		return C.PyUnicode_FromStringAndSize(nil, 0)
	}

	pinner := runtime.Pinner{}
	// cPointer := uintptr(unsafe.Pointer(stringBytes))
	cPointer := C._GoStringPtr(s)
	pinner.Pin(cPointer)
	res := C.PyUnicode_FromStringAndSize(cPointer, C.long(sLen))
	pinner.Unpin()

	return res
}
