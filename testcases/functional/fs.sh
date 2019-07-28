#!/bin/bash



# file system tests


# mkisofs
# mkisofs -V test-iso-file -J -jcharset=utf8 -r -o test.iso ./test/


# burn to disk
# growisofs -dvd-compat -Z /dev/sr0=./test.iso

# test variables
tag=fs
cmd=


types="ext2 ext3 ext4 vfat msdos"
device=$BLOCKDEV
mntpoint=$MNTPOINT
tmp_dir=$TMPDIR

mkdir -p $mntpoint
mkdir -p $tmp_dir


# testmain
main(){
for t in $types
do

mkfs -t $t 2> /dev/null || \
  { 
     echo mkfs -t $t FAIL
     test_exit 1
  }

mount -t $t $mntpoint 2> /dev/null || \
  {
     echo mount -t $t FAIL
     test_exit 1
  }

dd if=/dev/zero of=$tmp_dir/test_file count=128 bs=1M
cp $tmp_dir/test_file $mntpoint
if [ $? -eq 0 ]; then
  echo copy file successfull.
fi

umount $mntpoint
  [ $? -eq 0 ] &&  echo umount $t filesystem FAILED.

done

rm -rf $tmp_dir

}


main
