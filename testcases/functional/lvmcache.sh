#!/bin/bash
# lvmcache.sh 
# Author: lufei
# Date: 2019年 08月 05日 星期一 10:30:02 CST
# https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/logical_volume_manager_administration/lv#lvm_cache_volume_creation

source common.sh
source test.sh


cache_dev=$BLOCKDEVFORCACHE
data_dev=$BLOCKDEV
mntpoint=$MNTPOINT
tmpdir=$TMPDIR


# cache_size should be less than cache_dev size
# data_size should be less than data_dev size
cache_size=2G
data_size=8G

rw_tst()
{
  mkfs.ext4 /dev/VG/lv || \
    {
      echo FAILED: mkfs.ext4 /dev/VG/lv
      return 1
    }

  mkdir -p $mntpoint || return 2
  mkdir -p $tmpdir || return 2

  mount /dev/VG/lv $mntpoint || return 3
  dd if=/dev/zero of=$tmpdir/tmpfile bs=1M count=128 > /dev/null || return 4
  cp $tmpdir/tmpfile $mntpoint > /dev/null || return 5

  return 0
}

clean()
{
  umount /dev/VG/lv || return 1
  rm -rf $mntpoint

  lvremove -f /dev/VG/lv || return 2
  vgremove -f VG || return 3
  pvremove -f $cache_dev &&  pvremove -f $data_dev || return 4

  return 0 
  
}


run_key_func pvcreate -f $cache_dev
run_key_func pvcreate -f $data_dev
run_key_func vgcreate -f VG $cache_dev $data_dev
run_key_func lvcreate -y -L $data_size -n lv VG $data_dev
run_key_func lvcreate -y --type cache-pool -L $cache_size -n cpool VG $cache_dev
runfunc lvs -a -o name,size,attr,devices VG

run_key_func lvconvert -y -f --type cache --cachepool cpool VG/lv
runfunc lvs -a -o name,size,attr,devices VG

runfunc rw_tst

runfunc clean
