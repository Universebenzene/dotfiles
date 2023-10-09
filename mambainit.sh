# micromamba shell init --shell zsh --root-prefix=~/.micromamba
# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
export MAMBA_EXE='/usr/bin/micromamba';
export MAMBA_ROOT_PREFIX='/home/gsadmin/.micromamba';
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<
#

precmd_conda_info() {
    if [[ -n $CONDA_DEFAULT_ENV ]]; then
        CONDA_ENV="($CONDA_DEFAULT_ENV) "
    # When no conda environment is active, don't show anything
    else
        CONDA_ENV=""
    fi
}

# Run the previously defined function before each prompt
precmd_functions+=( precmd_conda_info )

# Allow substitutions and expansions in the prompt
setopt prompt_subst

PROMPT="$CONDA_ENV
$PS1"
