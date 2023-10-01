use std::ffi::c_int;
use std::pin::Pin;
use std::sync::Mutex;
use crate::pointer::CPointer;

#[repr(C)]
pub struct YdbConnection {
    driver: CPointer<Mutex<ydb::Client>>
}

#[no_mangle]
pub extern "C" fn ydb_check_linked_library()->c_int {
    1
}

#[no_mangle]
pub extern "C" fn ydb_connect()->Pin<Box<YdbConnection>>{
    panic!("not implemented")
}