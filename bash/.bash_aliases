# LS Aliases
alias ls='ls --color=auto'
alias ll='ls --color=auto -AhoF'
alias la='ls --color=auto -A'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

# GREP coloured aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Grep command history and installed packages
alias histg='history | grep'
alias pkgg='dpkg --list | grep'

# Only show uncommented lines from a config file
alias active='grep -v -e "^$" -e"^ *#"'

# Neofetch
alias fetch='neofetch --ascii_colors 4 5 7 6'

# Find current DPI settings from multiple sources
alias getdpi='cat /var/log/Xorg.0.log | grep DPI; xdpyinfo | grep dots; xrdb -query | grep dpi'

# Get current GPU load
alias igpuload='sudo intel_gpu_top'
alias dgpuload='nvidia-smi -a'

# i3lock with pixelation
alias lock='$FAKE_HOME/.i3/scripts/cool-i3-lock 1>/dev/null 2>&1'

# Pretty print the path
alias path='echo $PATH | tr -s ":" "\n"'

# fawk col_no will print col_no column
function fawk() {
    if [ -z "$1" ]; then
        # display usage if no parameters given
        echo "Usage: command | fawk n"
        echo "This will list the nth column of output of command."
    else
        first="awk '{print "
        last="}'"
        cmd="${first}\$${1}${last}"
        eval "$cmd"
    fi
}

# List the file permissions in octal
alias lsmodd="stat -c '%A %a %n'"

# Path related variables and aliases
export dots="$FAKE_HOME/dotfiles"

export GitHub='/media/ashhar/Resources/GitHub'
export gitatt='/media/ashhar/Resources/GitHub/_ToUse/gitattributes'
export gitig='/media/ashhar/Resources/GitHub/_ToUse/gitignore'

export Resources='/media/ashhar/Resources'
export Media='/media/ashhar/Media'

# FASD Aliases
# Quick open aliases
alias v='f -e vim'
alias nv='f -e nvim'
alias c='f -e code'

# Rerun previous command as sudo
alias fuck='sudo !!'

# Start a simple web server
alias pyserve='python -m http.server 7777'

# Find aliases
alias findhere='find . -name'

# Random command from the manpages
alias taocl='man -k $(find /usr/share/man/man[1-8]/ -not -name "*_*" -not -name "*::*" -printf "%f\n" | shuf -n 1|cut -d. -f1) | head -n 1'

# Copy the file contents to clipboard
alias pcc="xsel -b <"

# Sound a beep
alias beep="cvlc --play-and-exit /usr/share/sounds/freedesktop/stereo/complete.oga 1>/dev/null 2>&1"

# Delete the currently playing song
alias deletecurrent='rm ~/Music/"$(mpc current -f %file%)"'
