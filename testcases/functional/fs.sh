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


# testmain
main(){
for t in $types
do

mkfs -t $t 2> /dev/null || \
  { 
     echo mkfs -t $t FAIL
     test_exit 1
  }


done


}
