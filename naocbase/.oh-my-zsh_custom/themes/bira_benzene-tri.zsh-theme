# ZSH Theme - Preview: http://gyazo.com/8becc8a7ed5ab54a0262a470555c3eed.png
local return_code="%(?..%{$fg[red]%}%? <┘%{$reset_color%})"


if [[ $UID -eq 0 ]]; then
    local user="%{$fg_bold[red]%}%n%{$reset_color%}"
    local user_symbol="%{$fg_bold[red]%}#%{$reset_color%}"
    local user_dash="%{$fg[red]%}-%{$reset_color%}"
else
    local user="%{$fg_bold[green]%}%n%{$reset_color%}"
    local user_symbol="%{$fg_bold[cyan]%}$%{$reset_color%}"
    local user_dash="%{$fg_bold[black]%}-%{$reset_color%}"
#   local user_symbol="$"
fi

local host="%{$fg_bold[cyan]%}%m%{$reset_color%}"
local circlea="%{$fg[cyan]%}@%{$reset_color%}"
local time24="%{$fg[yellow]%}%*%{$reset_color%}"
local current_dir="%{$fg_bold[blue]%} %~%{$reset_color%}"
function filenum {
    echo $(ls | wc -l)
}

#local filenum="%{$fg[magenta]%}$(ls | wc -l)%{$reset_color%}"
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
    [[ $D > 0 ]] && printf '%dd ' $D
    [[ $H > 0 ]] && printf '%dh ' $H
    [[ $M > 0 ]] && printf '%dm ' $M
    printf '%ds' $S
}

function precmd() {
    if [ $timer ]; then
        timer_s=$(($SECONDS - $timer))
#       timer_s= #test
        timer_show=$(displaytime $timer_s)
        if [[ $timer_s -ge $min_show_time ]]; then
            line_time="%B${line_code}%b%{$fg[blue]%} >> %{$reset_color%}%{$fg_bold[yellow]%}${timer_show}%b"
        else
            line_time=""
        fi
        unset timer
    fi
}

PROMPT='${line_time}
┌[${user}${circlea}${host} ]${user_dash}[${time24}]${current_dir} $(git_prompt_info)
└[%{$fg[magenta]%}$(filenum)%{$reset_color%}] %B${user_symbol}%b '
#PS2=$'\e[0;33m%}%BContinue%{\e[0m%}%b > '
PS2=$'\e[0;33m%}%B%_ %{\e[0m%}%b\e[0;36m%}(Continue)%{\e[0m%} > '
RPS1="%B${return_code}%b"

autoload -Uz add-zsh-hook
add-zsh-hook preexec preexec
add-zsh-hook precmd precmd

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}{"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}*%{$reset_color%}%{$fg[yellow]%}}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[yellow]%}}"

# vim: ft=zsh
