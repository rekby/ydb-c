package main

/*

typedef struct ConnectionHandler {
   int connection_id;
} ConnectionHandler;

*/
import "C"
import (
	"fmt"

	"github.com/rekby/safemutex"
)

//export ydb_connect
func ydb_connect(connectionString *C.char, connectionStringLen C.int) C.struct_ConnectionHandler {
	connString := C.GoStringN(connectionString, connectionStringLen)
	connectionID := startConnect(globalConnections, connString)
	connectionHandler := C.struct_ConnectionHandler{
		connection_id: C.int(connectionID),
	}
	return connectionHandler
}

//export ydb_connect_wait
func ydb_connect_wait(connection C.struct_ConnectionHandler) C.int {
	var connMutex *safemutex.RWMutexWithPointers[connectionState]
	connID := int(connection.connection_id)
	globalConnections.RLock(func(synced *connectionStorage) {
		connMutex = synced.connections[connID]
	})

	if connMutex == nil {
		return -1
	}

	var done chan struct{}
	connMutex.RLock(func(synced connectionState) {
		done = synced.done
	})

	<-done
	var res C.int
	connMutex.RLock(func(synced connectionState) {
		if synced.err == nil {
			res = 0
		} else {
			fmt.Println("err: ", synced.err)
			res = 1
		}
	})

	return res
}

//export ydb_check_linked_library
func ydb_check_linked_library() C.int {
	return 1
}
