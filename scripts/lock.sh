#!/bin/bash

# called by the lock systemd service to lock screen on hibernate and sleep. instructions in dotfiles/instructions/fingerprint...
# symlink to /usr/bin/lock.sh. MAKE SURE IT IS EXECUTABLE

pid=$$
#xsecurelock &
slock &

# block until fingerprint is verified
until ! pidof slock || timeout 5 fprintd-verify marc; do
    echo "FAILURE"
done

#kill the pid for the lock and thisPid
#pkill xsecurelock
sudo pkill -9 slock
kill $pid
