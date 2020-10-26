function ros-params-get () {
    for i in `rosparam list | ag $1 | xargs`; do echo "${i}: " `rosparam get "${i}"`; done
}

function ros-topics-info () {
    for i in `rostopic list | ag $1 | xargs`; do echo "${i}: [`rostopic info ${i} | ag type`]"; done
}

function ros-typed-topic () {
    if [ $2 ]; then
        echo "search topics include string: $2"
        array=(`rostopic list | ag $2 | xargs`)
    else
        echo "search all topics"
        array=(`rostopic list | xargs`)
    fi
    echo "---"
    topic_type=$1
    for i in "${array[@]}"
    do
        if [ "`rostopic info ${i} | ag type | ag $topic_type`" ]
        then
            echo "${i} [`rostopic info ${i} | ag type`]"
        fi
    done
}

function cl () {
    if [ $1 = "b" ]; then
        local path
        path=`pwd`
        if [ $2 ]; then
            cd $COLCON_ROOT
            colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release --catkin-skip-building-tests --symlink-instal --packages-up-to ${2%/}
            cd $path
        else
            cd $COLCON_ROOT
            colcon $COLCON_ROOT
            colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release --catkin-skip-building-tests --symlink-instal
            cd $path
        fi
    elif  [ $1 == "cd" ]; then
        local prefix path str arr
        prefix=${2%/}
        if [ $prefix ]; then
            path=`roscd ${prefix} && pwd`
            str=`cat $path/cmake/${prefix}Config.cmake | grep src | xargs`
            arr=(${str// / })
            cd ${arr[1]%")"}
        else
            cd $COLCON_ROOT
        fi
    else
        echo "b or cd"
    fi
}
complete -F "_roscomplete_sub_dir" -o "nospace" "cl"
source /usr/share/colcon_cd/function/colcon_cd.sh
source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash

# PATH=$PATH:$HOME/.local/bin:$HOME/bin
# export PATH
# eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# if [ -n "$ZSH_VERSION" ]; then
#     eval "$(_ADE_COMPLETE=source_zsh ade)"
# else
#     eval "$(_ADE_COMPLETE=source ade)"
# fi
