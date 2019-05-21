cd ~/.task

# Run taskwarrior once to trigger recurrences, and mute the output
task > /dev/null 2>&1

printf "Most urgent tasks:\n"
task +urgent rc.context=none 2> /dev/null
printf "\n"
bash
