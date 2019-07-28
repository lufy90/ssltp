#/bin/bash


test01()
{

  echo Show current timedate settings.
  timedatectl
  [ $? -ne 0 ] && echo FAIL: timedatectl run failed.

}





test01
