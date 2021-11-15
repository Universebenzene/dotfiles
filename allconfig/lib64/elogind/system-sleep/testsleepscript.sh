#!/bin/bash
#case $1 in
#  pre)
#    # Put here any commands you want to be run when suspending or hibernating.
#    nmcli networking off
#    ;;
#  post)
#    # Put here any commands you want to be run when resuming from suspension or thawing from hibernation.
#    nmcli networking on
#    ;;
#esac
if [ "${1}" == "pre" ]; then
  # Do the thing you want before suspend here, e.g.:
  echo "we are suspending at $(date)..." > /root/systemd_suspend_test
elif [ "${1}" == "post" ]; then
  # Do the thing you want after resume here, e.g.:
  echo "...and we are back from $(date)" >> /root/systemd_suspend_test
# /bin/sh -c "awk '$1 !~ /^LID/ && $3 ~ /enabled/ {print $1}' /proc/acpi/wakeup | xargs -I{} echo '{}' > /proc/acpi/wakeup"
# /bin/sh -c "awk '$1 ~ /^LID/ && $3 ~ /disabled/ {print $1}' /proc/acpi/wakeup | xargs -I{} echo '{}' > /proc/acpi/wakeup"
fi
