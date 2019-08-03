#!/bin/bash
# functions related to stability test
# by lufei @ 20190725

steady()
{
# loop run cmd for tlen seconds.

local tlen=$1
shift
local cmd=$@

sleep $tlen &
local tpid=$!

while [[ $(ps -p $tpid -o comm=) == "sleep" ]]
  do
    $cmd
  done

}

