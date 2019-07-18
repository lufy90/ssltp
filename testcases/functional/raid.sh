
# create
mdadm -C /dev/md/test01 -ayes -l1 -n2 /dev/sdc[5,6]

# verify
mdadm -D /dev/md127

# remove
mdadm --stop /dev/md127
mdadm --remove /dev/md127
