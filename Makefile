all: go_library client_c_go_static client_c_go_dynamic

clean:
	rm -rf c_client/client_go_static c_client/client_go_dynamic go/_obj

client_c_go_static:
	gcc -o c_client/client_go_static c_client/client.c  -L go/_obj/ -l ydb_static

client_c_go_dynamic:
	gcc -o c_client/client_go_dynamic c_client/client.c  -L go/_obj/ -l ydb

client_c_rust_dynamic: rust_library_dynamic
	gcc -o c_client/client_rust_dynamic c_client/client.c  -L rust_ydb_client/target/debug/ -l rust_ydb_client

go_library:
	mkdir -p go/_obj
	go tool cgo -srcdir=go/ --objdir=go/_obj --import_runtime_cgo=false -exportheader ydb_header.h c_bind.go
	go build -C go -o _obj/libydb.so -buildmode=c-shared
	go build -C go -o _obj/libydb_static.a -buildmode=c-archive

rust_library_dynamic:
	cd rust_ydb_client && cargo build

	#cargo install --force cbindgen
	cbindgen --cpp-compat --lang c rust_ydb_client > rust_ydb_client/ydb_interface.h

