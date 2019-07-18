#!/bin/bash


source setting.sh

usage()
{
  cat <<-EOF >&2
usage: 
    ${0##*/} [ -f CMDFILES ] [ -s SCENARIO ]
    -f CMDFILES	Execute user defined list of testcases (separate with ',')
    -s SCENARIO	Execute user defined scenarios (separate with ',')
	EOF
  exit 0
}

runtest()
{
  local tag=$1
  local cmd=$2

  [ "${tag:0:1}" == "#" ] || \
  {
    echo start: $tag
    eval source $cmd
    echo end: $tag
  }
}

runfunc()
{
  :

}

runfile()
{
# run tests in file.
#  local cmdfile_dir=$1
  local cmdfile=$1
  [ ! -f $cmdfile ] && \
  {
    echo Cmdfile not exists:  $cmdfile >&2
    exit 1
  }
  local filesize=$(wc -l $cmdfile | awk '{print $1}')
  local cmdline=
  local tst_tag=
  local tst_cmd=

  local line=
  for line in `seq $filesize`
    do
      cmdline=$(sed -n "${line}p" $cmdfile)
      tst_tag=${cmdline%% *}
      tst_cmd=${cmdline#* }
#      echo tag: $tst_tag
#      echo cmd: $tst_cmd
      runtest "$tst_tag" "$tst_cmd"
    done
}

runscenario()
{
#  local scenario_dir=$1
  local scenario=$1
  [ -f $scenario ] || \
  {
    echo Scenario not exists: $scenario >&2
    exit 1
  }

  local f=
  for f in $(cat $scenario | grep -v ^# | tr '\n' ' ')
    do
      runfile $CMDFILE_DIR/$f
    done
}

main()
{
  local cmdfiles=
  local scenarios=
  while getopts f:hs: arg

  do case $arg in
    f) cmdfiles=$OPTARG ;;
    h) usage;;
    s) scenarios=$OPTARG ;;
    \?) usage ;;
    esac
  done
  # if no cmdfiles and scenario specified.
  [ -z "$cmdfiles" ] && [ -z "$scenarios" ] && \
    runscenario "${SCENARIO_DIR}/${DEFAULT_SCENARIO}"
  # else
  [ -n "$scenarios" ] && \   # if senario specified.
  {
    local scenario=
    for scenario in `echo $scenarios | tr ',' ' '`
      do runscenario ${SCENARIO_DIR}/$scenario
      done
  }

#  [ -n "$cmdfiles" ] && \   # if cmdfiles specified.
  [ -n "$cmdfiles" ] && \
  {
    local cmdfile=
    for cmdfile in `echo $cmdfiles | tr ',' ' '`
      do
        [ -f $cmdfile ] || cmdfile=${CMDFILE_DIR}/$cmdfile
        runfile $cmdfile
      done
  }

}

if [ "$0" = "./run.sh" ]; then
  main "$@"
fi
