package main

import (
	"context"
	"time"

	"github.com/rekby/safemutex"
	"github.com/ydb-platform/ydb-go-sdk/v3"
)

const operationTimeout = time.Second * 10

func startConnect(s *safemutex.RWMutexWithPointers[*connectionStorage], connectionString string) int {
	connStateMutex := &safemutex.RWMutexWithPointers[connectionState]{}
	go func() {
		ctx, ctxCancel := context.WithTimeout(context.Background(), operationTimeout)
		driver, err := ydb.Open(ctx, connectionString)
		ctxCancel()
		connStateMutex.Lock(func(state connectionState) connectionState {
			state.driver = driver
			state.err = err
			close(state.done)
			return state
		})
	}()

	var connectionID int
	s.Lock(func(connections *connectionStorage) *connectionStorage {
		connectionID = connections.NextID()
		connections.connections[connectionID] = connStateMutex
		return connections
	})
	return connectionID
}
