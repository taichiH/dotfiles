function replace-string () {
    find $3 -type f -print0 | xargs -0 sed -i -e "s/$1/$2/g"
}

function process-cpu-usage () {
    array=(`ps aux | ag $1 | xargs`);
    pidstat -p ${array[1]} 1
}

export EDITOR=emacs
