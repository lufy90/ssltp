## design.md
Follow this to construct this program.

Structure:
* test group tree:
+ scenario		group of cmdfiles in scenario/
  + cmdfile		testtag testcommand list in runtest/
    + testcase		executable in testcase/
      - functions	a single function in one single testcase ?


* Run a testcase
  a. kill when timeout
  b. run clean if teminated abnormally ?
  c. time tag before and after run testcase
  d. report test status: FAIL, PASS or CONF
  e. can execute independently

* Run a function
  Echo the check point execute result: PASS|CONF|FAIL
  Echo the count of the running check point

* Test function
  return 0  -- PASS
  return 1-63  -- FAIL
  return 64-127  -- CONF

** return 0 -- PASS, otherwise, FAIL

** PASS: function returns 0
   FAIL: 1. function returns none zero
         2. function timeout




* Test results
    * Output
Eg.
```
<<<test_start>>>
tag=tag1 stime=1557974730
cmdline=cmd1
contacts=""
analysis=exit
<<<test_output>>>
test_process: INFO: Timeout per run is 0h 05m 00s
function_point1: FAIL: xxxxxxxxx
function_point2: PASS: yyyyyyyyy
fucntion_point3: CONF: zzzzzzzzz

<<<execution_status>>>
initiation_status="ok"
duration=0 termination_type=exited termination_id=1 corefile=no
cutime=0 cstime=0
<<<test_end>>>
...
```

    * Result
```
Test Start Time: Thu May 16 10:29:09 2019
-----------------------------------------
Testcase                                           Result     Exit Value
--------                                           ------     ----------
tag1						   PASS	      0
...
-----------------------------------------------
Total Tests: 2002
Total Skipped Tests: 169
Total Failures: 32
Kernel Version: 3.10.0-957.el7.isoft.x86_64
Machine Architecture: x86_64
Hostname: func-111
```
