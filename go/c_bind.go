package ydb_c_binding

import "C"

/*
#include "../c_interface/interface.h"
*/

//export ydb_connect
func ydb_connect(connectionString *C.char, connectionStringLen C.int) C.struct_ConnectionHandler {
	connString := C.GoStringN(connectionString, connectionStringLen)
	connectionID := startConnect(globalConnections, connString)
	connectionHandler := C.struct_ConnectionHandler{
		connection_id: connectionID,
	}
	return connectionHandler
}

//export ydb_check_linked_library
func ydb_check_linked_library() C.int {
	return 1
}
