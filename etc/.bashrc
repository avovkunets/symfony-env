export LS_OPTIONS='--color=auto'
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

alias cdweb='cd /var/www/html'
alias sf='php app/console'

alias nr='/etc/init.d/nginx reload'

export PATH=/root/git-friendly:$PATH
shopt -s histappend

export PATH="$HOME/.symfony*/bin:$PATH"
