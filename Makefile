all: client_c_go_dynamic client_c_rust_dynamic go_headers rust_headers

in_progress: client_c_go_static rust_library_static client_c_rust_static

clean:
	rm -rf c_client/client_go_static c_client/client_go_dynamic go/_obj rust_ydb_client/target

client_c_go_static: go_library_static
	gcc -o c_client/client_go_static c_client/client.c  -L go/_obj/ -l ydb_static

client_c_go_dynamic: go_library_dynamic
	gcc -o c_client/client_go_dynamic c_client/client.c  -L go/_obj/ -l ydb

client_c_rust_dynamic: rust_library_dynamic
	gcc -o c_client/client_rust_dynamic c_client/client.c  -L rust_ydb_client/target/release/ -l rust_ydb_client

client_c_rust_static: rust_library_static
	gcc -o c_client/client_rust_static c_client/client.c  -L rust_ydb_client/target/x86_64-unknown-linux-musl/debug/ -l rust_ydb_client

go_headers:
	go tool cgo -srcdir=go/ --objdir=go/_obj --import_runtime_cgo=false -exportheader ydb_header.h c_bind.go

go_library_dynamic:
	mkdir -p go/_obj
	go build -C go -o _obj/libydb.so -buildmode=c-shared

go_library_static:
	go build -C go -o _obj/libydb_static.a -buildmode=c-archive

rust_headers:
	#cargo install --force cbindgen
	cbindgen --cpp-compat --lang c rust_ydb_client > rust_ydb_client/ydb_interface.h

rust_library_dynamic:
	cd rust_ydb_client && cargo build --release

rust_library_static:
	cd rust_ydb_client && cargo build --target=x86_64-unknown-linux-musl
