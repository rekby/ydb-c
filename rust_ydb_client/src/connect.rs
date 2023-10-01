use std::sync::mpsc;
use std::sync::mpsc::TryRecvError;
use crate::call::CallState;

pub(crate) fn connect(connection_string: String)->ConnectionState{
    let (sender, receiver) = mpsc::sync_channel(1);
    let builder = match ydb::ClientBuilder::new_from_connection_string(connection_string){
        Err(err)=>{
            return ConnectionState{
                done: receiver,
                client: Err(Box::new(err))
            }
        },
        Ok(builder)=>builder,
    };

    let client = match builder.client() {
        Err(err)=>
            return ConnectionState{
                done: receiver,
                client: Err(Box::new(err))
            },
        Ok(client)=>client,
    };

}

pub (crate) struct ConnectionState {
    done: mpsc::Receiver<bool>,
    client: Result<ydb::Client, Box<dyn std::error::Error>>,
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
        _ = self.done.recv();
    }
}
