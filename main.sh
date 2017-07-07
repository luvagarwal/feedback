DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/conf.sh"

rootAddr="${HOME}/.feedback"
customAddr="$rootAddr/Custom"
learningFactor=2

function main() {
    if [ $# == 0 ]; then
        help
        exit 0
    fi
    if [ $1 == "find" ]; then
        findContent ${@:2}
    elif [ $1 == "toggle" ]; then
        togglewindow
    else
        $1 ${@:2}
    fi
}

function help() {
    echo "Available commands: revise, find, show"
}

function togglewindow() {
    if [[ $(wmctrl -lpG | while read -a a; do w=${a[0]}; if (($((16#${w:2}))==$(xdotool getactivewindow))) ; then echo ${a[@]:8}; break; fi; done) == *'/.feedback/'* ]]; then xdotool windowminimize $(xdotool getactivewindow); else wmctrl -a /.feedback/; fi
}

function findContent() {
    grep $rootAddr -rni -e "$1" --color=auto
}

function monthAsNumber() {
    month=$1
    # 1 is random taken to generate a valid date
    echo $(date -d "1 $month" "+%m") 2>/dev/null
    if [ ! $? -eq 0 ]; then
        echo "Use -c flag for custom files" >&2
    fi
}

function dirAddr() {
    echo "$rootAddr/$3/$2/$1"
}

function preprocessDate() {
    # Takes date in different formats and return them
    # as dd-mm-yy

    d=$1
    if [[ $d =~ [a-z]+ ]]; then
        # Date looks like - 9Aug
        month=$(echo $d | sed "s/[0-9]*//g")
        d=$(echo $d | sed "s/$month/-$(monthAsNumber $month)-/")
    fi

    # dt as an array of day, month, year as numbers
    IFS='-/' read -a dt <<< $d
    length=${#dt[@]}

    # Prepend 0 in day
    if [ ${#dt[0]} -eq 1 ]; then dt[0]="0"${dt[0]}; fi || true
    # Prepend 0 in month
    if [ ${#dt[1]} -eq 1 ]; then dt[1]="0"${dt[1]}; fi || true
    # Prepend 20 in year
    if [ ${#dt[2]} -eq 2 ]; then dt[2]="20"${dt[2]}; fi || true

    if [ $length -eq 0 ]; then
        d=$(date +%d-%m-%Y)
    elif [ $length -eq 1 ]; then # Only day no given
        d=$(date +"${dt[0]}"-%m-%Y)
    elif [ $length -eq 2 ]; then # day no and month given
        d=$(date +"${dt[0]}-${dt[1]}"-%Y)
    else
        d="${dt[0]}-${dt[1]}-${dt[2]}"
    fi
    echo "$d"
}

function openFile() {
    if [ $(uname) == 'Linux' ]; then
        for f in $1; do
            "$EDITORCOMMAND" "$f" &
        done
        # find $1 -type f -exec "$EDITORCOMMAND" {} \;
    else
        # For Mac
        open -e $1 &
    fi
}

function openDir() {
    if [ $(uname) == 'Linux' ]; then
        nautilus $1 &
    else
        # For Mac
        open $1 &
    fi
}

function show() {

    if [ $# -eq 0 ]; then
        set -- $(date -d "$(todaysDate)" +%d-%m-%Y)
    fi

    if [ ! -d "$customAddr" ]; then
        mkdir -p "$customAddr"
    fi

    # Check if custom file
    case "$1" in
    "-c" )
        if [[ $(dirname $2) != "." ]]; then
            mkdir -p "$customAddr/$(dirname $2)"
        fi
        if [ ! -f "$customAddr/$2" ]; then
            touch "$customAddr/$2"
        fi
        echo "Opening $customAddr/$2"
        openFile "$customAddr/$2"
        ;;
    "-l" )
        ls "$customAddr"
        ;;
    "-o" )
		openDir "$customAddr"
		;;
    "-r" )
        rm "$customAddr/$2"
        ;;
    esac

    if [[ "$1" =~ "-"* ]]; then exit 0; fi

    for fname in $@; do
        d=$(preprocessDate $fname)
        echo "Opening $d"
        IFS='-' read -a d <<< $d
        DirAddr=$(dirAddr ${d[@]})
        if [ ! -d "$DirAddr" ]; then
            mkdir -p "$DirAddr"
            for f in ${DEFAULTFILES[@]}; do
                touch "$DirAddr/$f"
            done
        fi
        openFile "$DirAddr/*"
    done
}

function todaysDate() {
    # Decrement date by 1 if midnight (0, 7)
    d=$(date +%H)
    meriraat=7
    if [ $d -lt $meriraat ]; then
        echo $(date "--date=$(date) - 1 day")
    else
        echo $(date)
    fi
}

function revise() {

    # If argument is passed which could either be a
    # file name in date format or a custom file (More
    # Custom files in show function)
    if [ ! $# -eq 0 ]; then
        show $@
    fi

    subtract=0
    space="$learningFactor"
    date_today=$(todaysDate)

    for i in `seq 1 $DAYSREVISION`; do
        d=$(date "--date=$date_today - $subtract day" +%d-%m-%Y)
        IFS='-' read -a dt <<< $d
        if [ -d "$(dirAddr ${dt[@]})" ]; then
            show $d
        fi
        subtract=$(($subtract + $space))
        space=$(($space * $learningFactor))
    done
}

main $@
