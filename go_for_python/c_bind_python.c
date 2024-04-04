#include "c_bind_python.h"

static struct PyMethodDef methods[] = {
    {"ydb_python_read_result", (PyCFunction)ydb_python_read_result, METH_VARARGS}, // functions, exported as python module function
    {NULL, NULL}
};

static struct PyModuleDef module = {
    PyModuleDef_HEAD_INIT,
    "go_for_python", // module name, same as for PyInit_...
    NULL,
    -1,
    methods,
};

PyMODINIT_FUNC PyInit_go_for_python(void) {
    return PyModule_Create(&module);
}
