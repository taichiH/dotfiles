case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth

shopt -s histappend

HISTSIZE=10000000
HISTFILESIZE=20000000

shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes

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

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias grep='grep --exclude-dir=.svn'

export SSH_USER=higashide
export SVN_SSH="ssh -l ${SSH_USER}"

if [ "$(which hub)" != "" ]; then
    $(hub alias -s)
fi
export ROSCONSOLE_FORMAT='[${severity}] [${time}] [${node}:${logger}]: ${message}'

source `catkin locate --shell-verbs`

function rossethsr {
    export ROS_HOSTNAME=$(hostname -I | awk '{print$1}')
    export ROS_IP=$ROS_HOSTNAME
    export ROS_MASTER_URI=http://172.18.0.2:11311
}

function rossetaero {
    export ROS_HOSTNAME=$(hostname -I | awk '{print$1}')
    export ROS_IP=$ROS_HOSTNAME
    export ROS_MASTER_URI=http://192.168.10.52:11311
    # rossetip
}

function getRarm() {
    js=$(rostopic echo -n 1 /joint_states | grep "position")
    s_r=$(echo $js | cut -d[ -f2 | cut -d, -f24)
    s_p=$(echo $js | cut -d[ -f2 | cut -d, -f23)
    s_y=$(echo $js | cut -d[ -f2 | cut -d, -f25)
    e=$(echo $js | grep "position" | cut -d[ -f2 | cut -d, -f18)
    echo "0,0,positionHand,_object_name:,_arm:rarm,_grasp_type:front_grasp,_shoulder_r:${s_r},_shoulder_p:${s_p},_shoulder_y:${s_y},_elbow:${e},_ref_score:0.0"
}

function getLarm() {
    js=$(rostopic echo -n 1 /joint_states | grep "position")
    s_r=$(echo $js | cut -d[ -f2 | cut -d, -f9)
    s_p=$(echo $js | cut -d[ -f2 | cut -d, -f8)
    s_y=$(echo $js | cut -d[ -f2 | cut -d, -f10)
    e=$(echo $js | grep "position" | cut -d[ -f2 | cut -d, -f3)
    echo "0,0,positionHand,_object_name:,_arm:larm,_grasp_type:front_grasp,_shoulder_r:${s_r},_shoulder_p:${s_p},_shoulder_y:${s_y},_elbow:${e},_ref_score:0.0"
}

function getRarmWrist() {
    js=$(rostopic echo -n 1 /joint_states | grep "position")
    one=$(echo $js | cut -d[ -f2 | cut -d, -f29)
    two=$(echo $js | cut -d[ -f2 | cut -d, -f28)
    three=$(echo $js | cut -d[ -f2 | cut -d, -f19)
    echo "0,0,switchGrasp,_arm:rarm,_grasp_type:,_tool_root:${one},_tool_middle:${two},_tool_end:${three}"
}

function getLarmWrist() {
    js=$(rostopic echo -n 1 /joint_states | grep "position")
    one=$(echo $js | cut -d[ -f2 | cut -d, -f14)
    two=$(echo $js | cut -d[ -f2 | cut -d, -f13)
    three=$(echo $js | cut -d[ -f2 | cut -d, -f4)
    echo "0,0,switchGrasp,_arm:larm,_grasp_type:,_tool_root:${one},_tool_middle:${two},_tool_end:${three}"
}

export PYTHONPATH=/usr/lib:$PYTHONPATH
source /opt/ros/kinetic/setup.bash
source ${HOME}/ros/kinetic/devel/setup.bash
