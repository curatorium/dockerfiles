[ -z "$PS1" ] && return;

export SHELL="/bin/bash";

eval "$(dircolors ~/.bash_colors)";
eval "$(starship init bash)";

ulimit -S -c 0      # Don't want core dumps

set -o notify
set +o noclobber
set -o ignoreeof

# Enable options:
shopt -s cdspell
shopt -s cdable_vars
shopt -s checkhash
shopt -s checkwinsize
shopt -s sourcepath
shopt -s no_empty_cmd_completion
shopt -s cmdhist
shopt -s histappend histreedit histverify
shopt -s extglob       # Necessary for programmable completion.

# enable bash completion
. /etc/bash_completion
. ~/.bash_aliases
. ~/.bash_env
