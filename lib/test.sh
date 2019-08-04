#!/bin/bash
# test.sh
# functions for test framwork

num=0
runfunc()
{
# run functional point
# output function test results: 
#   PASS for function return code 0, FAIL for function return others.

  local func=$1
  shift
  local args="$@"

  local rc=
  local stdo=
  local stde=

  echo args: $args
  eval $func $args
  rc=$?

  local rs=
  case $rc in
    0) rs=PASS  ;;
#    [1-9]|[1-5][0-9]|6[0-3]) rs=FAIL ;;
#    6[4-9]|[7-9][0-9]|1[0-2][0-7]) rs=CONF ;;
    *) rs=FAIL ;;
  esac

  num=$((num+1))
  echo -e "${num}\t${func}\t${rs}\t${rc}"
  return $rc
}

export -f runfunc
run_key_func()
{
  # exit test if func failed.
  runfunc $@
  local rc=$?
  [ $rc -eq 0 ] || exit 1

}

