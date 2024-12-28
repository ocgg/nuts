#!/bin/bash

# ENV VARIABLES ###############################################################

# ROOT_DIR=$(realpath "$(dirname "$0")")
NOTES_PATH="$HOME/shared/notes/"
NOTES_BASENAME=$(basename "$NOTES_PATH")

FILES=$(find "$NOTES_PATH" ! -name "$NOTES_BASENAME" -type f -printf "%P\n")
# DIRS=$(find "$NOTES_PATH" ! -name "$NOTES_BASENAME" -type d -printf "%P\n")
# DIRS_AND_FILES=$(find "$NOTES_PATH" ! -name "$NOTES_BASENAME" -type d -printf "%P/\n" -o -type f -printf "%P\n")

TERM_WIDTH=$(tput cols)
# TERM_HEIGHT=$(tput lines)

# FUNCTIONS ###################################################################

# Prints help and exit
usage_and_exit() {
    echo 'Usage:'
    echo "  $0                  search any note"
    echo "  $0 find <query>     search for a note with query, opens it if only 1 found, else opens the search with query"
    echo "                               'search', 'f' and 's' are aliases for find"
    echo "  $0 <query>          like 'find', for any string that doesn't match any other parameter"
    exit
}

# Format the note to not exceed colwidth, and renders markdown
format_note() {
    # TODO: interpret markdown (ruby script ?), if note is markdown
    fmt -s -w $colwidth < "$chosenfile"
}

# Without arg:  opens fzf to search for any note
# With arg:     if only one match, prints the note, else opens fzf with query
find_note() {
    local choice chosenfile colwidth query
    [ -n "$1" ] && query=$1

    choice=$(fzf --query "$query" -1 --border=top --border-label="COUCOU" <<< "$FILES")

    # echo "$choice"
    chosenfile="$NOTES_PATH$choice"
    # file_date=$(date -r "$chosenfile" "+%Y-%m-%d %H:%M")
    colwidth=$(("$TERM_WIDTH" / 2 - 4))

    formatted_file=$(format_note)
    echo "$formatted_file"
}

# MAIN ########################################################################

case $1 in
    "")                     find_note;;
    find | search | f | s)  find_note "$2";;
    help | -h | --help)     usage_and_exit;;
    *)                      find_note "$1";;
esac

# lines_count=$(wc -l <<< "$formatted_file")

# echo $lines_count, $TERM_HEIGHT

# if (("$lines_count" > "$TERM_HEIGHT" - 1)); then
#     pr --columns 2 -w "$TERM_WIDTH" -l "$TERM_HEIGHT" -D "Last modified: $file_date" <<< "$formatted_file"
# else
#     echo "$formatted_file"
# fi
