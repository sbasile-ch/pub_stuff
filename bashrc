# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias h=history
alias vi=vim

alias c0='cp -f /home/xml/config/My/XMLGWConfig.pm.libxml.0 /home/xml/config/My/XMLGWConfig.pm'
alias c1='cp -f /home/xml/config/My/XMLGWConfig.pm.libxml.1 /home/xml/config/My/XMLGWConfig.pm'
alias r='/usr/sbin/apachectl restart'
alias t='tail -f /etc/httpd/logs/error_log'

export HISTCONTROL=ignoreboth

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi
