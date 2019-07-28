#!/bin/bash
# setting.sh
# for global settings of test


# SSLTP variables
export SSLTPROOT=$PWD
export PATH=$PATH:${SSLTPROOT}/lib
export CMDFILE_DIR=${SSLTPROOT}/runtest

export DEFAULT_SCENARIO=default
export SCENARIO_DIR=${SSLTPROOT}/scenarios


# test variables
export CASETIMEOUT=300
export FUNCTIMEOUT=100
export BLOCKDEV="/dev/sdg5"
export YUMREPO=

export MNTPOINT=/tmp/ssltp_mntpoint
export TMPDIR=/tmp/ssltp_tmpdir
