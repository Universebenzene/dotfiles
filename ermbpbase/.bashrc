# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
#if [[ $- != *i* ]] ; then
#	# Shell is non-interactive.  Be done now!
#	return
#fi


# Put your fun stuff here.

export EDITOR=vim

alias ip='ip -c'

#=========CONFUSING_LOCALE=========#
#export XMODIFIERS="@im=fcitx"
#export QT_IM_MODULE=fcitx
#export GTK_IM_MODULE=fcitx
#eval "$(dbus-launch --sh-syntax --exit-with-session)"
#export LANG=zh_CN.UTF-8
#==================================#

#============TTY-LOCALE============#
if [ "$TERM" = "linux" ]; then
    export LANG=en_US.UTF-8
fi
#==================================#

#=======TERMINAL-TRANSPARENT=======#
if [ -n "$WINDOWID" ]; then
 TRANSPARENCY_HEX=$(printf 0x%x $((0xffffffff * 90 / 100)))
 xprop -id "$WINDOWID" -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY "$TRANSPARENCY_HEX"
fi
#==================================#

#===========PSs-SETTINGs===========#
#export PS1="©°[\[\033[1;32m\]\u\[\033[0;32m\]@\[\033[1;35m\]\h \[\033[0m\]]\[\033[1;30m\]-\[\033[0m\][\[\033[0;33m\]\t\[\033[0m\]] \[\033[1;34m\]\w\[\033[0m\]\n©¸[\[\033[0;35m\]\$(ls | wc -l)\[\033[0m\]] \[\033[1;36m\]\\$ \[\033[0m\]"
. ~/Downloads/archtogentooconfs/ps1try
#PS1="\[\e]0;\u@\h:\w\a\]$PS1"
case ${TERM} in
  xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'

    ;;
  screen)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
    ;;
esac
export PS2="\[\033[1;33m\]Continue\[\033[0m\] > "
#==================================#
export PGPLOT_DEV=/XWINDOW
export PGPLOT_FONT=/usr/lib64/pgplot/grfont.dat
