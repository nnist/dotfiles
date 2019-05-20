cd ~/.task
printf "Most urgent tasks:\n\n"
task +urgent rc.verbose= rc.context=none
printf "\n"
bash
