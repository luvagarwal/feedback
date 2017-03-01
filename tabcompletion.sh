# fb [tab] - show, revise, find
# fb show [tab] - -c, -o some suggestions
# fb show -c [tab] - files

_autocomplete()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    mainopts="show revise find"
    showopts="-c -o"

    if [[ ${prev} == "fb" ]] ; then
        COMPREPLY=( $(compgen -W "${mainopts}" -- ${cur}) )
    elif [[ ${prev} == "show" && ${cur} == "-"* ]]; then
    	COMPREPLY=( $(compgen -W "${showopts}" -- ${cur}) )
    elif [[ ${prev} == "-c" ]]; then
        customDir="${HOME}/.feedback/Custom/"
        files="$(find $customDir -type f | sed -e "s:$customDir::g")"
    	COMPREPLY=( $(compgen -W "$files" -- ${cur}) )
    fi
}

complete -F _autocomplete fb
