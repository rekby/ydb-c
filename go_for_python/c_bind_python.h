#define PY_SSIZE_T_CLEAN
#include <Python.h>

PyObject* ydb_python_read_result(PyObject* self, PyObject* args);
PyObject* python_connect(PyObject* self, PyObject* args);

int _py_read_one_string_arg(PyObject *args, char **content, size_t *bytes_len);
