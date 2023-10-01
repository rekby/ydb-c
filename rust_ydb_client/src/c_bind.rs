use std::ffi::{c_char, c_int, CStr};
use std::pin::Pin;
use std::sync::{Arc, Mutex};
use crate::call::CallState;
use crate::connect::connect;
use crate::pointer::{CPointer, Pointer};
use crate::runtime::runtime_init;

#[repr(C)]
pub struct YdbConnection {
    client: CPointer<Mutex<Arc<CallState<ydb::Client>>>>
}

#[no_mangle]
pub extern "C" fn ydb_check_linked_library()->c_int {
    1
}

#[no_mangle]
pub unsafe extern "C" fn ydb_connect(connection_string: *const c_char)->Pin<Box<YdbConnection>>{
    let rt = runtime_init();
    let rt_guard = rt.enter();

    let c_str = CStr::from_ptr(connection_string);
    let rust_connection_string = c_str.to_str().expect("connection string was bad");
    let conn_state = connect(rust_connection_string);

    let ydb_connection = YdbConnection{
        client: CPointer::new(Mutex::new(conn_state))
    };

    drop(rt_guard);
    return Pin::new(Box::new(ydb_connection))
}

#[no_mangle]
pub extern "C" fn ydb_connect_has_result(ydb_connection: &YdbConnection)->c_int{
    ydb_connection.client.ensure_valid();
    if ydb_connection.client.data.lock().unwrap().is_done(){
        1
    } else {
        0
    }
}

#[no_mangle]
pub extern "C" fn ydb_connect_wait(ydb_connection: &YdbConnection)->c_int{
    let state = ydb_connection.client.data.lock().unwrap().clone();
    state.wait_done();
    let has_errors = if let Some(err) = state.err.lock().unwrap().as_ref(){
        println!("{}", err);
        1
    } else {
        0
    };
    has_errors
}

#[no_mangle]
pub extern "C" fn ydb_connect_free(ydb_connection: Pin<Box<YdbConnection>>){
    drop(ydb_connection)
}