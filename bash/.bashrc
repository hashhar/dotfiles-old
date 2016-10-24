# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# CUSTOMIZATIONS TO SHELL
###############################################################################
FAKE_HOME="/home/ashhar"
export PATH="/usr/games:$PATH"

##### Fancy startup #######################################
cmatrix -sbu 9
neofetch --image "ascii" --ascii_distro "Ubuntu-GNOME" --colors 6 7 6 6 7 7
if [ -x /usr/games/cowsay -a -x /usr/games/fortune ]; then
    fortune -eac | tee >(head -n 1 >> "${FAKE_HOME}/.local/logs/fortune-category-log") | tail -n +3 | cowsay -f "$(find /usr/share/cowsay/cows/ -type f | sort -R | head -1)" -W $((COLUMNS - 10)) | lolcat
fi

##### Simple colourful prompt #############################
bash_prompt_command()
{
    local NONE="\[\033[0m\]"    # unsets color to term's fg color

    # regular colors
    local K="\[\033[0;30m\]"    # black
    local R="\[\033[0;31m\]"    # red
    local G="\[\033[0;32m\]"    # green
    local Y="\[\033[0;33m\]"    # yellow
    local B="\[\033[0;34m\]"    # blue
    local M="\[\033[0;35m\]"    # magenta
    local C="\[\033[0;36m\]"    # cyan
    local W="\[\033[0;37m\]"    # white

    # emphasized (bolded) colors
    local EMK="\[\033[1;30m\]"
    local EMR="\[\033[1;31m\]"
    local EMG="\[\033[1;32m\]"
    local EMY="\[\033[1;33m\]"
    local EMB="\[\033[1;34m\]"
    local EMM="\[\033[1;35m\]"
    local EMC="\[\033[1;36m\]"
    local EMW="\[\033[1;37m\]"

    # background colors
    local BGK="\[\033[40m\]"
    local BGR="\[\033[41m\]"
    local BGG="\[\033[42m\]"
    local BGY="\[\033[43m\]"
    local BGB="\[\033[44m\]"
    local BGM="\[\033[45m\]"
    local BGC="\[\033[46m\]"
    local BGW="\[\033[47m\]"

    local UC=$EMG               # user's color
    [ $UID -eq "0" ] && UC=$R   # root's color

    PS1=""
    force_color_prompt=yes
    if [ $(id -u) -eq 0 ]; then
        if [ "$force_color_prompt" = yes ]; then
            PS1+="${debian_chroot:+($debian_chroot)}${EMR}\u@\h${NONE}:${EMB}[\w]${R}\n\$ ${NONE}"
        else
            PS1+="${debian_chroot:+($debian_chroot)}\u@\h:\wi\n\$ "
        fi
    else
        if [ "$force_color_prompt" = yes ]; then
            PS1+="${debian_chroot:+($debian_chroot)}${EMG}\u@\h${NONE}:${EMB}[\w]${NONE}\n\$ ${NONE}"
        else
            PS1+="${debian_chroot:+($debian_chroot)}\u@\h:\wi\n\$ "
        fi
    fi
}
bash_prompt_command
unset bash_prompt_command

##### Customize behaviour of the shell ####################
bind TAB:menu-complete
bind \C-SPACE:complete
# ** will match all files and zero or more directories and subdirectories
shopt -s globstar
# Fix small spelling mistakes in cd
shopt -s cdspell
# Don't exit shell if jobs are running
shopt -s checkjobs
# Try hostname completion
shopt -s hostcomplete
# Load the history substitution into the readline buffer instead of running it
shopt -s histverify
# Add newlines to history instead of semicolons where possible
shopt -s lithist

export HISTSIZE=1000
export HISTFILESIZE=10000
export BROWSER="firefox"

##### Color in the shell ##################################
# Coloured GCC errors and warnings
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

##### Coloured man pages ##################################
man() {
    if [ "$TERM" = 'linux' ]; then
        env \
            LESS_TERMCAP_mb=$(printf "\e[34m") \
            LESS_TERMCAP_md=$(printf "\e[1;31m") \
            LESS_TERMCAP_me=$(printf "\e[0m") \
            LESS_TERMCAP_se=$(printf "\e[0m") \
            LESS_TERMCAP_so=$(printf "\e[30;43m") \
            LESS_TERMCAP_ue=$(printf "\e[0m") \
            LESS_TERMCAP_us=$(printf "\e[32m") \
                /usr/bin/man "$@"
    else
        env \
            LESS_TERMCAP_mb=$(printf "\e[1;34m") \
            LESS_TERMCAP_md=$(printf "\e[38;5;9m") \
            LESS_TERMCAP_me=$(printf "\e[0m") \
            LESS_TERMCAP_se=$(printf "\e[0m") \
            LESS_TERMCAP_so=$(printf "\e[30;43m") \
            LESS_TERMCAP_ue=$(printf "\e[0m") \
            LESS_TERMCAP_us=$(printf "\e[38;5;10m") \
                /usr/bin/man "$@"
    fi
}

# LOCAL INSTALLATIONS
###############################################################################
##### github.com/arialdomartini/oh-my-git #################
. "$FAKE_HOME/.local/git/oh-my-git/prompt.sh"

##### github.com/huyng/bashmarks ##########################
. "$FAKE_HOME/.local/git/bashmarks/bashmarks.sh"
# bind completion command for bj,bp,bd to _comp
shopt -s progcomp
complete -F _comp bj
complete -F _comp bp
complete -F _comp bd

##### github.com/dvorka/hstr ##############################
export HH_CONFIG=hicolor
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"   # mem/file sync
# if this is interactive shell, then bind hh to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hh \C-j"'; fi

##### github.com/shyiko/commacd ###########################
. "$FAKE_HOME/.local/git/commacd/commacd.bash"

##### github.com/facebook/PathPicker ######################
export PATH="$FAKE_HOME/.local/git/PathPicker/:$PATH"

##### github.com/clvv/fasd ################################
eval "$(fasd --init auto)"

#### github.com/tmuxinator/tmuxinator #####################
#. ${FAKE_HOME}/.local/src/tmuxinator.bash

# INSTALLED SOFTWARE
###############################################################################

# NPM and Node
export NVM_DIR="$FAKE_HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[[ -r $NVM_DIR/bash_completion ]] && . $NVM_DIR/bash_completion

# Golang
export GOPATH="$FAKE_HOME/dev/golang"

# GNOME Development
export PATH="$FAKE_HOME/.local/bin:$PATH"

# Anaconda3
export PATH="/opt/anaconda3/bin:$PATH"
