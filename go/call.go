package ydb_c_binding

type CallState interface {
	IsDone() bool
	WaitDone()
}
