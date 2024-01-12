#!/usr/bin/bash

#
#region shortcuts

# overrides
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias du='du -kh'    # Makes a more readable output.
alias df='df -kTh'

# cd
alias --     -='cd -'
alias --     ~='cd ~'
alias --    ..='cd ..'
alias --   ...='cd ../..'
alias --  ....='cd ../../..'
alias -- .....='cd ../../../..'

# ls
alias ll='ls -halFv --group-directories-first'
alias ls='ls -h --color'
alias la='ls -hA'
alias lm='ll | more'       #  Pipe through 'more'
alias lr='ll -R'           #  Recursive ls.
alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
alias lt='ls -ltr'         #  Sort by date, most recent last.
alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lu='ls -ltur'        #  Sort by/show access time,most recent last.
alias l='ls -hCF'
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...

alias h='history'
alias j='jobs -l'
alias which='type -a'

# pretty-print PATH:
alias path='echo -e ${PATH//:/\\n}';
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}';

# typos
alias xs='cd'
alias vf='cd'
alias moer='more'
alias moew='more'
alias kk='ll'

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias watch='watch --color'
fi

# bash debug
alias debug="set -o nounset; set -o xtrace";

# xdebug
function xdebug_on() {
	server="$1";
    export PHP_IDE_CONFIG="serverName=$server";
    export XDEBUG_CONFIG="idekey=MIHAI_STANCU_STORM remote_host=$server remote_enable=1";
}
function xdebug_off() {
    export XDEBUG_CONFIG="remote_enable=0"
}

#endregion shortcuts


#
#region symfony
alias sf='$(find-up -f bin/console)';
alias cc="sf cache:clear";
alias cache:clear="sf cache:clear";
alias clear:cache="sf cache:clear";
alias config="sf debug:config";
alias dump='php $(find-up -f vendor/bin/var-dump-server)';
alias env-vars="sf debug:container --env-vars";
alias env-var="sf debug:container --env-var";
alias events="sf debug:event-dispatcher";
alias event="sf debug:event-dispatcher";
alias event="sf doctrine:fixtures:load"
alias migrate="sf doctrine:migrations:migrate";
alias migrate:diff="sf doctrine:migrations:diff";
alias params="sf debug:container --parameters";
alias param="sf debug:container --parameter";
alias psysh='php $(find-up -f vendor/bin/psysh) --cwd /app';
alias router="sf debug:router";
alias schema:create="sf doctrine:schema:create";
alias schema:drop="sf doctrine:schema:drop";
alias schema:update="sf doctrine:schema:update";
alias schema:validate="sf doctrine:schema:validate";
alias services="sf debug:container";
#endregion symfony


#
#region laravel
alias artisan="php artisan";
alias db:seed="artisan db:seed";
alias migrate="artisan migrate";
alias migrate:fresh="artisan migrate:fresh";
alias migrate:refresh="artisan migrate:refresh";
alias queue:work="artisan queue:work";
alias route:list="artisan route:list";
alias tinker="artisan tinker";
#endregion laravel


#
#region generic

#
# Find which parent directory contains $search
# -d | --dir  Output the directory path
# -f | --file Output the file path
function find-up {
  # Parse options & arguments.
  local inc="true";
  local search="";
  while [ "$1" != "$EOL" ]; do case "$1" in
      -f | --file  ) inc="true"   ;;
      -d | --dir   ) inc="false"  ;;
      *            ) search="$1"  ;;
  esac; shift; done


  # Iterate through parent directories until a match is found.
  local path=$(pwd);
  while [[ "$path" != "" && ! -e "$path/$search" ]]; do
    path=${path%/*};
  done
  if [[ ! -e "$path/$search" ]]; then
    return;
  fi

  # Output the result.
  if [[ $inc == 'true' ]]; then
    path="$path/$search";
  fi
  echo "$path";
}

function memusage() {
  local count=${1:-5}; shift;
  (
    printf "SIZE %%MEM COMMAND\n";
    ps -A --sort -rss -o comm,pmem,rss                                                                  \
    | awk '{ pcts[$1] += $2; abs[$1] += $3*1024; c[$1]++; } END {for (cmd in pcts) { printf "%s %s %s %s\n", abs[cmd], pcts[cmd], cmd, c[cmd] }}' \
    | sort -rn                                                                                          \
    | numfmt --to=iec                                                                                   \
  )                                                                                                     \
  | column -t                                                                                           \
  | head -n$count                                                                                       \
  ;
}

function extract {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}

# TAR entire directory
function maketar {
    tar cvzf "${1%%/}.tar.gz"  "${1%%/}/";
}

# ZIP entire directory
function makezip {
    zip -r "${1%%/}.zip" "$1" ;
}

#endregion
