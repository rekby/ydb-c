#include <stdio.h>

#include "../c_interface/interface.h"

int main(){
    int res;
    res = ydb_check_linked_library();
    printf("check %d\n", res);
    return 0;
}
