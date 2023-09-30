#include <stdio.h>
#include <string.h>

#include "../c_interface/ydb_interface.h"

int main(){
    int res;
    res = ydb_check_linked_library();
    printf("check %d\n", res);

    char *connectionString = "grpc://localhost:2136/local";

    ConnectionHandler connection;
    connection = ydb_connect(connectionString, strlen(connectionString));

    int connected = ydb_connect_wait(connection);

    printf("connect result: %d\n", connected);

    return 0;
}
