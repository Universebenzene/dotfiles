#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ip='ip -c'
#alias ccal='ccal -ug' #ccal m yyyy

eval $(dircolors -b)

export EDITOR=vim

if [ "$TERM" = "linux" ]; then
    export LANG=en_US.UTF-8
fi

#=======TERMINAL-TRANSPARENT=======#
#if [ -n "$WINDOWID" ]; then
# TRANSPARENCY_HEX=$(printf 0x%x $((0xffffffff * 78 / 100)))
# xprop -id "$WINDOWID" -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY "$TRANSPARENCY_HEX"
#fi
#==================================#

#===========PSs-SETTINGs===========#
#PS1='[\u@\h \W]\$ '
#export PS1="┌[\[\033[1;33m\]\u\[\033[0;36m\]@\[\033[1;32m\]\h \[\033[0m\]]\[\033[0;33m\]-\[\033[0m\][\[\033[1;35m\]\t\[\033[0m\]] \[\033[1;34m\]\w\[\033[0m\]\n└[\[\033[0;32m\]\s \[\033[0;35m\]\V\[\033[0m\]] \[\033[1;36m\]\$ \[\033[0m\]"
#export PS1="┌[\[\033[1;32m\]\u\[\033[0;36m\]@\[\033[1;36m\]\h \[\033[0m\]]\[\033[0;33m\]-\[\033[0m\][\[\033[1;30m\]\D{%D}\[\033[0m\]] \[\033[1;34m\]\w\[\033[0m\]\n└[\[\033[0;33m\]\t\[\033[0m\]] \[\033[1;36m\]\\$ \[\033[0m\]"

function roundseconds() {
  # rounds a number to 3 decimal places
  echo m=$1";h=0.5;scale=4;t=1000;if(m<0) h=-0.5;a=m*t+h;scale=0;a/t;" | bc
}

function bash_getstarttime() {
  # places the epoch time in ns into shared memory
  date +%s.%N >"/dev/shm/${USER}.bashtime.${1}"
}

function bash_getstoptime() {
  # reads stored epoch time and subtracts from current
  local endtime=$(date +%s.%N)
  local starttime=$(cat /dev/shm/${USER}.bashtime.${1})
  roundseconds $(echo $(eval echo "$endtime - $starttime") | bc)
}

function displaytime() {
    local T=$1
    local D=$((T/60/60/24))
    local H=$((T/60/60%24))
    local M=$((T/60%60))
    local S=$((T%60))
    [[ $D > 0 ]] && printf '%dd' $D
    [[ $H > 0 ]] && printf ' %dh' $H
    [[ $M > 0 ]] && printf ' %dm' $M
    [[ $S > 0 || $T == 0 ]] && printf ' %ds' $S
}

ROOTPID=$BASHPID
bash_getstarttime $ROOTPID

PS0='$(bash_getstarttime $ROOTPID)'
#PPS1='$(displaytime $(bash_getstoptime $ROOTPID))'
PPS1=''
function dir_stat() {
    test -w $1 && echo "" || echo " !"
}

PDR='$(dir_stat .)'

export PS1="┌[\[\033[1;32m\]\u\[\033[0;36m\]@\[\033[1;36m\]\h \[\033[0m\]]\[\033[1;30m\]-\[\033[0m\][\[\033[0;33m\]\t\[\033[0m\]] \[\033[1;34m\]\w\[\033[0m\]\[\033[0;31m\]$PDR\[\033[0;32m\]$PPS1\[\033[0m\] \n└[\[\033[0;35m\]\$(ls | wc -l)\[\033[0m\]] \[\033[1;36m\]\\$ \[\033[0m\]"

function runonexit() {
  rm /dev/shm/${USER}.bashtime.${ROOTPID}
}

trap runonexit EXIT

export PS2="\[\033[1;33m\]Continue\[\033[0m\] > "
#==================================#
case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'

    ;;
  screen)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
    ;;
esac
#=========Science Software=========#
export PGPLOT_DEV=/XWINDOW
export PGPLOT_FONT=/usr/lib/grfont.dat
export PGPLOT_RGB=/usr/lib/rgb.txt
#export NETPBM_INC="-I/usr/include/netpbm"
#export NETPBM_LIB="-L/usr/lib -lnetpbm"
