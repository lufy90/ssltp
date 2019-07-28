#!/bin/bash
# test.sh
# functions for test framwork

runfunc()
{
# run functional point
# output function test results: 
#   PASS for function return code 0
#   FAIL for return code 1-63
#   CONF for return code 64-127

  local func=$1
  shift
  local args=$@

  local rc=
  local stdo=
  local stde=

  echo args: $args
#  rs=$($func $args 2>&1)
  $func $args
  rc=$?
#  [ ${#rs} -ge 100 ] && rs="${rs::100} ..."

  local rs=
  case $rc in
    0) rs=PASS  ;;
    [1-9]|[1-5][0-9]|6[0-3]) rs=FAIL ;;
    6[4-9]|[7-9][0-9]|1[0-2][0-7]) rs=CONF ;;
  esac

  echo -e "${func}\t${rs}\t${rc}"

#  echo rs: $rs

}

