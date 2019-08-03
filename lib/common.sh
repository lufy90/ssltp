#!/bin/bash
#common.sh
# coommon used functions


chk_rpm_exists()
# check if rpm package installed, return count of NOT installed.
{
  local rc=0
  for pkg # in $@
    do rpm -q $pkg > /dev/null 2>&1 || \
      {
        echo CONF $pkg not installed.
        rc=$((rc+1))
      }
    done
  [ $rc -le 255 ] || \
    echo "WARNING: only count of NOT installed package(s) less than or equal to 255 could returned correctly."
  return $rc
# for dpkg, use dpkg -s <pkg name>
}

