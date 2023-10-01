use std::sync::{Mutex, Once};

static RUNTIME:Mutex<tokio::runtime::Runtime> = Mutex::new(tokio::runtime::Runtime::new().unwrap());
