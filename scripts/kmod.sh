#!/bin/bash
# set -euox pipefail

kver=$(cd /usr/lib/modules && echo *)

cat >/tmp/fake-uname <<EOF
#!/usr/bin/env bash

if [ "\$1" == "-r" ] ; then
  echo ${kver}
  exit 0
fi

exec /usr/bin/uname \$@
EOF
install -Dm0755 /tmp/fake-uname /tmp/bin/uname

#workaround for akmod permission issue
chmod 777 /var/tmp

### AKMOD usage
PATH=/tmp/bin:$PATH 
PATH=/tmp/bin:$PATH akmods --force --kernels ${kver} 

### DKMS test
# dkms autoinstall -k ${kver}
# GIT_URL=https://github.com/intel/ipu7-drivers.git
# git clone "$GIT_URL" /tmp/ipu7-drivers
# cd /tmp/ipu7-drivers
# dkms add .
# dkms autoinstall -v ipu7-drivers/0.0.0
# cat /var/lib/dkms/ipu7-drivers/0.0.0/build/make.log



chmod 755 /var/tmp