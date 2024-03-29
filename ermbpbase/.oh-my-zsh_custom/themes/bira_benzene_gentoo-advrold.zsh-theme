# ZSH Theme - Preview: http://gyazo.com/8becc8a7ed5ab54a0262a470555c3eed.png
local return_code="%(?..%{$fg[red]%}%? <┘%{$reset_color%})"
local line_code="%(?..%{$fg[red]%}%? <┐%{$reset_color%})"

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[yellow]%}{"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}*%{$reset_color%}%{$fg[yellow]%}}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[yellow]%}}"

if [[ $UID -eq 0 ]]; then
    local user="%{$fg_bold[red]%}%n%{$reset_color%}"
    local circlea="%{$fg[magenta]%}@%{$reset_color%}"
    local user_symbol="%{$fg_bold[red]%}#%{$reset_color%}"
    local user_dash="%{$fg[red]%}-%{$reset_color%}"
else
    local user="%{$fg_bold[green]%}%n%{$reset_color%}"
    local circlea="%{$fg[cyan]%}@%{$reset_color%}"
    local user_symbol="%{$fg_bold[cyan]%}$%{$reset_color%}"
    local user_dash="%{$fg_bold[black]%}-%{$reset_color%}"
fi

local host="%{$fg_bold[magenta]%}%m%{$reset_color%}"
local time24="%{$fg[yellow]%}%*%{$reset_color%}"
function filenum {
    echo $(ls | wc -l)
}

function dir_stat() {
    test -w ${PWD} && echo "" || echo "%{$fg[red]%} !%{$reset_color%}"
}

local rvm_ruby=''
if which rvm-prompt &> /dev/null; then
  rvm_ruby='%{$fg[red]%}‹$(rvm-prompt i v g)›%{$reset_color%}'
else
  if which rbenv &> /dev/null; then
    rvm_ruby='%{$fg[red]%}‹$(rbenv version | sed -e "s/ (set.*$//")›%{$reset_color%}'
  fi
fi
local git_branch="$(git_prompt_info)"

local timer_s=0
local timer_show=0
local min_show_time=1

function preexec() {
    timer=${timer:-$SECONDS}
}

function displaytime {
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

function fillbar() {
    local git_branch_n="$(git_current_branch)"
    branch_len=0
    if [[ ${#git_branch_n} -ne 0 ]]; then
        (( branch_len = ${#git_branch_n} + 3 ))
        if [[ -n $(git status -s 2> /dev/null) ]]; then
            (( branch_len = branch_len + 1 ))
        fi
    fi
    if [ $timer ]; then
        timer_s=$(($SECONDS - $timer))
#       timer_s= #test
    fi
    timer_show=$(eval echo $(displaytime $timer_s))
    time_len=${#timer_show}
    test -w ${PWD} && dirst_show="" || dirst_show=" x"
    dirst_len=${#dirst_show}
    local nts=5
    local nds=4 #=%num of current_dir
    # shorter than /x/y..\w then ..\w
    (( fillsn = ${COLUMNS} - ${#${(%):-[%n@%m-]-[%*]-%~}} - dirst_len - branch_len - time_len - nts ))
    if [[ "${#${(%):-[%n@%m-]-[%*]-%~}} + ${dirst_len} + ${branch_len} + 1" -lt ${COLUMNS} ]]; then
        current_dir="%{$fg_bold[blue]%} %~%{$reset_color%}"
    elif [[ "${#${(%):-[%n@%m-]-[%*]-%-2~..%1~}} + ${dirst_len} + ${branch_len} + 1" -ge ${COLUMNS} ]]; then
        current_dir="%{$fg_bold[blue]%} ..%1~%{$reset_color%}"
    else
        (( cdr_len=${COLUMNS} - ${#${(%):-[%n@%m-]-[%*]-%-2~..}} - dirst_len - branch_len ))
        current_dir="%{$fg_bold[blue]%} %-2~%${cdr_len}<..<%~%<<%{$reset_color%}"
    fi
    fillss=" "
    while [ ${#fillss} -lt ${fillsn} ]; do fillss=" ${fillss}"; done
#   (( dfs = ${#${(%):-[%n@%m-]-[%*]-%~}} + ${branch_len} + ${time_len} + ${nts} )) # show -[${dfs}]-[${COLUMNS}]
    if [[ $timer_s -ge $min_show_time ]]; then
        if [[ "${#${(%):-[%n@%m-]-[%*]-%~}} + ${dirst_len} + ${branch_len} + ${time_len} + ${nts}" -ge ${COLUMNS} ]]; then
            PS_TAIL=''
            RPS1="%B${line_code}%b %{$reset_color%}%{$fg_bold[yellow]%}${timer_show}%b%{$fg[blue]%} <<%b"
        else
            PS_TAIL="${fillss}%{$reset_color%}%{$fg_bold[yellow]%}${timer_show}%b%{$fg[blue]%} <<%b"
            RPS1="%B${return_code}%b"
        fi
    else
        PS_TAIL=''
        RPS1="%B${return_code}%b"
    fi
    unset timer
}

PROMPT='┌[${user}${circlea}${host} ]${user_dash}[${time24}]${current_dir}$(dir_stat)$(git_prompt_info)${PS_TAIL}
└[%{$fg[magenta]%}$(filenum)%{$reset_color%}] %B${user_symbol}%b '
PS2=$'\e[0;33m%}%B%_ %{\e[0m%}%b\e[0;36m%}(Continue)%{\e[0m%} > '

autoload -Uz add-zsh-hook
add-zsh-hook preexec preexec
add-zsh-hook precmd fillbar

# vim: ft=zsh
