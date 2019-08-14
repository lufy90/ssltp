## ssltp
Super Simple Linux Test Program
One of Super Simple Projects

## Features
* Similar usage as LTP
 * Has scenarios and command lists
 * Similar principles of writing testcases, requires less than LTP
* Coded by shell
* Simple maintenance
 * Less dependency than LTP
 * Run from scratch instead of compiling and installing
 * Global variables are set in `setting.sh`

## How to write testcase
Generate header of testcase script:
```
# ./scripts/gentest.sh testcases/function/test
```
Then edit testcases/function/test with editor, always run your check point with 
`run_key_fun` or `runfunc`, like:
```
run_key_func chkpoint1 arguments
runfunc chkpoint2 arguments
```
Difference of `run_key_func` and `runfunc`:
`run_key_func` would exit certain test when `chkpoint1` returns non-zero value.
`run_func` would just echo `FAIL` and going on the next tests if `chkpoint2` 
returns non-zero value.
