all: go_library client_c_go

clean:
	rm -rf c_client/client_go go/_obj

client_c_go:
	gcc -o c_client/client_go c_client/client.c  -L go/_obj/ -l ydb

go_library:
	mkdir -p go/_obj
	go tool cgo -srcdir=go/ --objdir=go/_obj --import_runtime_cgo=false -exportheader ydb_header.h c_bind.go
# 	go build -C go -o _obj/libydb.so -buildmode=c-shared
	go build -C go -o _obj/libydb.a -buildmode=c-archive

