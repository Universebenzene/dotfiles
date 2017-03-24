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

PROMPT='┌[${user}${circlea}${host} ]${user_dash}[${time24}]${current_dir} $(git_prompt_info)
└[%{$fg[magenta]%}$(filenum)%{$reset_color%}] %B${user_symbol}%b '
RPS1="%B${return_code}%b"
#PS2=$'\e[0;33m%}%BContinue%{\e[0m%}%b > '
PS2=$'\e[0;33m%}%B%_ %{\e[0m%}%b\e[0;36m%}(Continue)%{\e[0m%} > '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}{"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}*%{$reset_color%}%{$fg[yellow]%}}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[yellow]%}}"

