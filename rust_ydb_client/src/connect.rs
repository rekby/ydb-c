use std::sync::mpsc;
use std::sync::mpsc::TryRecvError;
use crate::call::CallState;

pub (crate) struct ConnectionState {
    done: mpsc::Receiver<bool>,
    client: ydb::Client,
    err: Box<dyn std::error::Error>,
}

impl CallState for ConnectionState {
    fn is_done(&self) -> bool {
        match self.done.try_recv(){
            Ok(_)=>true,
            Err(TryRecvError::Empty)=>false,
            Err(TryRecvError::Disconnected)=>true,
        }
    }

    fn wait_done(&self) {
        todo!()
    }
}