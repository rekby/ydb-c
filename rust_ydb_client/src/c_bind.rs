use std::ffi::c_int;

#[no_mangle]
pub extern "C" fn ydb_check_linked_library()->c_int {
    1
}
