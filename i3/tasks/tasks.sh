cd ~/.task
printf "Most urgent tasks:\n"
task +urgent rc.context=none 2> /dev/null
printf "\n\nScheduled tasks for today:\n"
task schedule rc.context=none 2> /dev/null
printf "\n\n"
bash
