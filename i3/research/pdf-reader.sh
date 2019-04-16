cd ~/syncthing/research
#sleep 2
#evince --class=pdf-container
firejail --whitelist=/home/nicole/syncthing/research/ --net=none evince --class=pdf-container
bash
