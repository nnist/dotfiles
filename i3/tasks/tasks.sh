cd ~/.task
printf "Most urgent tasks:\n\n"
task +urgent rc.verbose= rc.context=none
printf "\n\nScheduled tasks for today:\n\n"
task schedule rc.verbose= rc.context=none
printf "\n\n"
bash
