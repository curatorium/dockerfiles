#
# Laravel shortcuts
#
alias artisan="php artisan";
alias db:seed="artisan db:seed";
alias migrate="artisan migrate";
alias migrate:fresh="artisan migrate:fresh";
alias migrate:refresh="artisan migrate:refresh";
alias queue:work="artisan queue:work";
alias route:list="artisan route:list";
alias tinker="artisan tinker";

#
# Behavior overrides
#
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'


alias h='history'
alias j='jobs -l'
alias which='type -a'

# Enable colors if possible
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

# ls aliases
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

alias du='du -kh'    # Makes a more readable output.
alias df='df -kTh'

# some cd aliases
alias --     -='cd -'
alias --     ~='cd ~'
alias --    ..='cd ..'
alias --   ...='cd ../..'
alias --  ....='cd ../../..'
alias -- .....='cd ../../../..'

# Typos - highly personnal and keyboard-dependent :-)
alias xs='cd'
alias vf='cd'
alias moer='more'
alias moew='more'
alias kk='ll'

function memusage() {
  count=${1- 5}; shift;
  (
    printf "SIZE %%MEM COMMAND\n";
    ps -A --sort -rss -o comm,pmem,rss                                                                  \
    | awk '{ pcts[$1] += $2; abs[$1] += $3*1024; }
      END {for (cmd in pcts) { printf "%s %s %s\n", abs[cmd], pcts[cmd], cmd }}'                        \
    | sort -rn                                                                                          \
    | numfmt --to=iec                                                                                   \
  )                                                                                                     \
  | column -t                                                                                           \
  | head -n$count                                                                                       \
  ;
}
