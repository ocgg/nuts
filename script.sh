#!/bin/bash

NOTES_PATH="$HOME/shared/notes/"
NOTES_BASENAME=$(basename "$NOTES_PATH")

only_files_cmd=$(find "$NOTES_PATH" ! -name "$NOTES_BASENAME" -type f -printf "%P\n")
# only_dirs_cmd=$(find "$NOTES_PATH" ! -name "$NOTES_BASENAME" -type d -printf "%P\n")
# dirs_and_files_cmd=$(find "$NOTES_PATH" ! -name "$NOTES_BASENAME" -type d -printf "%P/\n" -o -type f -printf "%P\n")

choice=$(fzf --border=top --border-label="COUCOU" <<< "$only_files_cmd")

# echo "$choice"
chosenfile="$NOTES_PATH$choice"

term_width=$(tput cols)
term_height=$(tput lines)
colwidth=$(("$term_width" / 2 - 10))
formatted_file=$(fmt -s -w $colwidth < "$chosenfile")


pr --columns 2 -S" | " -o 2 -w "$term_width" -l "$term_height" -D "%Y-%m-%d %H:%M" <<< "$formatted_file"

# res=$(pr --columns 2 -S" | " -w "$term_width" -l "$term_height" -D "%Y-%m-%d %H:%M" <<< "$formatted_file")
# less <<< "$res"

