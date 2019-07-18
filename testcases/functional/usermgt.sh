#!/bin/bash




# create user


# user attributes

# user expire days from 19700101
# test from su - $username, failed with "Your account has expired; please contact your system administrator"
# alternatively achieved by editing /etc/shadow
usermod -e ${expire_date} $username


