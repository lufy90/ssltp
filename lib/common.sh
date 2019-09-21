#!/bin/bash
#common.sh
# coommon used functions


chk_rpm_exists()
{
# check if rpm package installed, return count of NOT installed.
  local rc=0
  for pkg # in $@
    do rpm -q $pkg > /dev/null 2>&1 || \
      {
        echo CONF $pkg not installed.
        rc=$((rc+1))
      }
    done
  [ $rc -le 255 ] || \
    {
      echo "WARNING: return value is $rc."
      rc=255
    }

  return $rc
# for dpkg, use dpkg -s <pkg name>
}

chk_cmd_exists()
{
  local rc=0
  for cmd
    do which $cmd > /dev/null 2>&1 || \
      {
        echo INFO: $cmd not found.
        rc=$((rc+1))
      }
    done
  [ $rc -le 255 ] || \
    {
      echo "WARNING: return value is greater than 255"
      rc=255
    }
  return $rc
}


chk_service_up()
{
  local rc=0
  for service
    do systemctl is-active $service || \
      {
        echo INFO: $service not active.
        rc=$((rc+1))
      }
    done
  [ $rc -le 255 ] || \
    {
      echo "WARNING: return value is greater than 255"
      rc=255
    }
  return $rc
}

# get block device size:
# blockdev --getsize64 /dev/sdc7
