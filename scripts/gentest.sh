#!/bin/bash
# gentest.sh
# lufei @ 20190802
# generatet testcase


gentest(){
  local name=$1
  
  mkdir -p $(dirname $name)

  cat > $name  << EOF
#!/bin/bash
# $(basename $name) 
# Author: $USER
# Date: $(date)
# 
# Attention: run check point with  runfunc or run_key_func
# 
# Description:
# 

source common.sh
source test.sh

func1()
{
: # Construct check point func1 here

}

EOF

}


gentest $1
