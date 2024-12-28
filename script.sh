#!/bin/bash

# ENV VARIABLES ###############################################################

# Test notes path
NOTES_PATH="$HOME/code/nuts/notes/"
# NOTES_PATH="$HOME/shared/notes/"
NOTES_BASENAME=$(basename "$NOTES_PATH")

# ROOT=$(realpath "$(dirname "$0")")

FILES=$(find "$NOTES_PATH" ! -name "$NOTES_BASENAME" -type f -printf "%P\n")
DIRS=$(find "$NOTES_PATH" ! -name "$NOTES_BASENAME" -type d -printf "%P\n")
# DIRS_AND_FILES=$(find "$NOTES_PATH" ! -name "$NOTES_BASENAME" -type d -printf "%P/\n" -o -type f -printf "%P\n")

TERM_WIDTH=$(tput cols)
# TERM_HEIGHT=$(tput lines)

# FUNCTIONS ###################################################################

# Prints help and exit
usage_and_exit() {
    echo 'Usage:'
    echo "  $0                  search any note"
    echo "  $0 find <query>     search for a note with query, opens it if only 1 found, else opens the search with query"
    echo "  $0 search <query>   alias for 'find'"
    echo "  $0 <query>          like 'find', for any string that doesn't match any other parameter"
    exit
}

error_and_exit() {
    >&2 echo -e "Error: $1"
    exit
}

no_note_error() {
    local msg="\tNo note in $NOTES_PATH\n\tChange NOTE_PATH value or try 'new' argument to create a new note"
    error_and_exit "$msg"
}

# FIND & DISPLAY NOTE ###############################################

# Format the note to not exceed colwidth, and renders markdown
format_note() {
    # TODO: interpret markdown (ruby script ?), if note is markdown
    fmt -s -w $colwidth < "$selection"
}

# Without arg:  opens fzf to search for any note and prints selection
# With arg:     if only one match, prints the note, else opens fzf with query
find_note() {
    local selection colwidth query
    [ -n "$1" ] && query=$1

    selection=$NOTES_PATH$(fzf --query "$query" -1 --border=top --border-label="COUCOU" <<< "$FILES")

    # file_date=$(date -r "$selection" "+%Y-%m-%d %H:%M")
    colwidth=$(("$TERM_WIDTH" / 2 - 4))

    formatted_file=$(format_note)
    echo "$formatted_file"
}

# NEW NOTE ##########################################################

create_note_dir() {
    # ask user for a dir name, with completion from NOTES_PATH
    local basedir=$PWD
    cd "$NOTES_PATH" || exit
    read -e -p "New directory > " new_dir
    cd "$basedir" || exit
    
    # TODO: Check if newdir is valid:
        # - not a file
        # - doesn't already exist
        # - name not blank (?)

    # create dir recursively
    mkdir -p "$NOTES_PATH$new_dir"
    
    selection="$new_dir"
}

select_or_create_dir() {
    local fzf_label="New note directory"
    local fzf_prompt="Select a directory > "
    local new=">> Create a new directory..."
    local selection options
    # Add "create a new dir" and "." to notes directories list
    options=$(printf "%s\n%s\n%s" "$new" "." "$DIRS")

    selection=$(fzf --border=top --border-label="$fzf_label" --prompt="$fzf_prompt" <<< "$options")
    # if "create a new dir" selected
    [ "$selection" == "$new" ] && create_note_dir

    selection="$NOTES_PATH$selection/"
    echo "$selection"
}

ask_new_note_name() {
    local name
    read -p "New note name > " name

    # TODO: check if name is valid:
        # - not empty

    # append ".md" to new_note_name if not already present
    name="${name%.md}.md" 
    echo "$name"
}

# Let the user choose for a directory in NOTES_PATH,
# then prompt the user for a filename & opens default editor
new_note() {
    new_note_dir=$(select_or_create_dir)
    # echo "new note dir: $new_note_dir"
    new_note_name=$(ask_new_note_name)
    # echo "new note name: $new_note_dir$new_note_name"
    new_note_path="$new_note_dir$new_note_name"

    touch "$new_note_path"
    # open file with default editor
    $EDITOR "$new_note_path"
}

# MAIN ########################################################################


case $1 in
    "" | find | search)
        [ -z "$FILES" ] && no_note_error
        find_note "$2";;
    help | -h | --help)     usage_and_exit;;
    new)                    new_note;;
    *)                      find_note "$1";;
esac

# lines_count=$(wc -l <<< "$formatted_file")

# echo $lines_count, $TERM_HEIGHT

# if (("$lines_count" > "$TERM_HEIGHT" - 1)); then
#     pr --columns 2 -w "$TERM_WIDTH" -l "$TERM_HEIGHT" -D "Last modified: $file_date" <<< "$formatted_file"
# else
#     echo "$formatted_file"
# fi
