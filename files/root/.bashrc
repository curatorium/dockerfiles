[ -z "$PS1" ] && return;

export SHELL="/bin/bash";

eval "$(dircolors ~/.bash_colors)";

ulimit -S -c 0      # Don't want core dumps

set -o notify
set +o noclobber
set -o ignoreeof

#
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

#
# enable bash completion
[[ -f /etc/bash_completion ]] && . /etc/bash_completion
. ~/.bash_aliases
. ~/.bash_env


#
# Enable prompt colors
red=$(tput setaf 1);
green=$(tput setaf 2);
blue=$(tput setaf 4);
reset=$(tput sgr0);
PS1='\[$red\]\u\[$reset\]@\[$green\]\h\[$reset\]:\[$blue\]\w\[$reset\]\$ ';
