pub(crate)trait CallState {
    fn is_done(&self) ->bool;
    fn wait_done(&self);
}

