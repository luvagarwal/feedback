RootAddr="${HOME}/.NeverForget"

function main() {
    if [ $# == 0 ]; then
        help
        exit 1
    fi
    if [ $1 == "find" ]; then
        findContent ${@:2}
    else
        $1 ${@:2}
    fi
}

function help() {
    echo "Available commands: revise, find, show"
}

function findContent() {
    echo $(grep $RootAddr -rn -e "$1")
}

function monthAsNumber() {
    month=$1
    echo $(date -d "$month 1 1" "+%m")
}

function preprocessDate() {
    d=$1
    if [[ $d =~ [a-z]+ ]]; then
        # Date looks like - 9Aug
        month=$(echo $d | sed "s/[0-9]*//g")
        d=$(echo $d | sed "s/$month/-$(monthAsNumber $month)/")
    fi

    IFS='-/' read -a dt <<< $d
    length=${#dt[@]}

    if [ $length -eq 0 ]; then
        d=$(date +%d-%m-%Y)
    elif [ $length -eq 1 ]; then
        # prepend 0 in date
        if [ ${#dt[0]} -eq 1 ]; then
            dt[0]="0"${dt[0]}
        fi
        d=$(date +"${dt[0]}"-%m-%Y)
    elif [ $length -eq 2 ]; then
        # prepend 0 in date
        if [ ${#dt[0]} -eq 1 ]; then
            dt[0]="0"${dt[0]}
        fi
        # prepend 0 in month
        if [ ${#dt[1]} -eq 1 ]; then
            dt[0]="0"${dt[1]}
        fi
        d=$(date +"${dt[0]}-${dt[1]}"-%Y)
    else
        d="${dt[0]}-${dt[1]}-${dt[2]}"
    fi
    echo "$d"
}

function dirAddr() {
    echo "$RootAddr/$2/$1/$0"
}

function show() {
    if [ $# -eq 0 ]; then
        set -- $(date +%d-%m-%Y)
    fi

    for d in $@; do
        d=$(preprocessDate $d)
        echo $d
        IFS='-' read -a d <<< $d
        DirAddr=$(dirAddr ${d[@]})
        if [ ! -d "$DirAddr" ]; then
            mkdir -p "$DirAddr"
            touch "$DirAddr/index"
            touch "$DirAddr/todo"
        fi
        gedit $DirAddr/* &
    done
}

function todaysDate() {
    # Decrement date by 1 if midnight (0, 6)
    d=$(date +%H)
    meriraat=6
    if [ $d -lt $meriraat ]; then
        echo $(date "--date=$(date) - 1 day")
    else
        echo $(date)
    fi
}

function revise() {
    intelligence_factor=2
    subtract=1
    days_revision=8
    date_today=$(todaysDate)
    for i in `seq 1 $days_revision`; do
        d=$(date "--date=$date_today - $subtract day" +%d-%m-%Y)
        IFS='-' read -a dt <<< $d
        if [ -d "$(dirAddr ${dt[@]})" ]; then
            show $d
        fi
        subtract=$(($subtract * $intelligence_factor))
    done
}

main $@
