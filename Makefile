all: go_library client_c_go

clean:
	rm -rf c_client/client_go go/_obj

client_c_go:
	gcc -L go/_obj/ -l _cgo_.o -o c_client/client_go c_client/client.c

go_library:
	mkdir -p go/_obj
	go tool cgo -srcdir=go/ --objdir=go/_obj c_bind.go
	cd go
	go build -o go/_obj/ydb.so -buildmode=c-shared

