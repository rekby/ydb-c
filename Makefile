all: go_library client_c_go_static client_c_go_dynamic

clean:
	rm -rf c_client/client_go_static c_client/client_go_dynamic go/_obj

client_c_go_static:
	gcc -o c_client/client_go_static c_client/client.c  -L go/_obj/ -l ydb_static

client_c_go_dynamic:
	gcc -o c_client/client_go_dynamic c_client/client.c  -L go/_obj/ -l ydb

go_library:
	mkdir -p go/_obj
	go tool cgo -srcdir=go/ --objdir=go/_obj --import_runtime_cgo=false -exportheader ydb_header.h c_bind.go
	go build -C go -o _obj/libydb.so -buildmode=c-shared
	go build -C go -o _obj/libydb_static.a -buildmode=c-archive

