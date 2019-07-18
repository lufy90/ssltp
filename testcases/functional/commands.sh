#!/bin/bash

# for automatically generate test list file.
tag=commond
cmd="testcases/functional/command.sh"


timeout=300



cmds1="ls cd pwd mkdir mv rmdir cp vi cat touch file ln 
      grep chown chmod sort wc fdisk df mount mkfs tar dd 
      zip unzip gzip"

cmds2="ps vmstat top iostat sar"

cmds3="ifconfig ping ssh scp telnet"

cmds4="kill man who date more ps su sudo uname service chkconfig"

cmds5="useradd userdel usermod groupadd groupdel groupmod id"

cmds6="ls abcd"
for i in $cmds1 $cmds2 $cmds3 $cmds4 $cmds5
#for i in $cmds6
do
which $i > /dev/null 2>&1
rv=$?
if [ $rv -ne 0 ]; then
echo $i ........... FAIL
else
echo $i ........... PASS
fi
done


