case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=100000
HISTFILESIZE=200000
shopt -s checkwinsize
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
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

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

function noetic-mode () {
    source /opt/ros/noetic/setup.bash
    export ROSCONSOLE_FORMAT='[${severity}] [${node}] [${function}] [${line}] [${time}]:${message}'
    # source ~/dotfiles/.local.bash
    # source ~/dotfiles/bash_custom/vcs.bash
    # source ~/dotfiles/bash_custom/ros.bash
    # source ~/dotfiles/bash_custom/util.bash
}

function ros2-setup () {
    source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash
    export RCUTILS_COLORIZED_OUTPUT=1
    export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
    # export CYCLONEDDS_URI=file:///opt/autoware/cyclonedds_config.xml
    export ROS_DOMAIN_ID=100
    export RCUTILS_CONSOLE_OUTPUT_FORMAT="[{severity} {time}] [{name}]: {message} ({function_name}() :{line_number})"
}

function foxy-mode () {
    source /opt/ros/foxy/setup.bash
    ros2-setup
}

function galactic-mode () {
    source /opt/ros/galactic/setup.bash
    ros2-setup
}

function tvm-mode () {
    export TVM_HOME=${HOME}/tvm/tvm
    export PYTHONPATH=$TVM_HOME/python:$TVM_HOME/topi/python:${PYTHONPATH}
}

function clang-format-dir () {
    find . -name '*.h' -or -name '*.hpp' -or -name '*.cpp' | xargs clang-format-12 -i -style=file $1
}
function clang-format-file () {
    clang-format-12 -i -style=file $1
}

function pep8-ros2 () {
    autopep8 $1 -r --in-place --max-line-length 99
}

EDITOR=emacs

export PATH=~/.local/bin:$PATH
export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="/usr/local/libtorch/lib:$LD_LIBRARY_PATH"

galactic-mode

# for vtune-gui
export PATH="${PATH}:/opt/intel/oneapi/vtune/2021.7.1/bin64"
