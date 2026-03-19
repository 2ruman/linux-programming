#!/bin/bash

STEP_BY_STEP=1
UPDATE_FIRST=0

function pause() {
    read -n 1 -r -s -p "Press enter to continue... " ans
    while true; do
        case $ans in
            "" ) echo ""; break;
            ;;
            * ) read -n 1 -r -s ans
            ;;
        esac
    done
}

function ask_action() {
    while true; do
        read -n 1 -r -s -p "Press [Enter] to run / [s] to skip / [t] to terminate... " ans
        case $ans in
            [Ss]* ) echo -e "\nSkipping..."; return 1;
            ;;
            [Tt]* ) echo -e "\nTerminating..."; exit 1;
            ;;
            "" ) echo -e "\nRunning..."; return 0;
            ;;
            * ) echo -e "\nInvalid answer... $ans"
            ;;
        esac
    done
}

function do_action() {
    sh -c "$1"
}

function next() {
    local cmd="$*" # Or just "$1"
    echo -e "\n================================================================================"
    echo -e "\nNext command is:\n$cmd\n"

    if [ $STEP_BY_STEP -eq 1 ]; then
        ask_action && do_action "$cmd"
    else
        do_action "$cmd"
    fi
}

function next_warned() {
    local msg="$1"
    local cmd="$2"
    echo -e "\n$msg"
    if [ $STEP_BY_STEP -eq 1 ]; then
        pause
    fi
    next "$cmd"
}

[[ $UPDATE_FIRST -eq 1 ]] && sudo apt update

next "$(cat << EOF
cd ~
sudo passwd
EOF
)"

next "$(cat << EOF
sudo mkdir /truman
sudo chown truman:truman /truman
sudo sh -c '(grep -q "Truman-added" /etc/fstab && echo "Already applied") ||
(printf "\n# Truman-added\n/truman\t\t/home/truman/world\tnone\tdefaults,bind\t0\t0\n" >> /etc/fstab && echo "Done")'
sudo mount -a
sudo systemctl daemon-reload
EOF
)"

next "$(cat << EOF
cd /truman
mkdir personal workspace tools utilities temp test vmware
EOF
)"

next "$(cat << EOF
sudo snap install upnote
EOF
)"

next "$(cat << EOF
cd ~; mkdir chrome; cd chrome;
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb;
EOF
)"

next "$(cat << EOF
sudo apt install -y openjdk-21-jdk
EOF
)"

next "$(cat << EOF
sudo apt install -y python3
sudo apt install -y python3-pip
EOF
)"

next "$(cat << EOF
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 2
# sudo update-alternatives --config python
EOF
)"

next "$(cat << EOF
sudo apt install -y git
$(./get-git-conf.sh)
EOF
)"

next_warned "[!] Please make sure if you already set up the ssh keys
$(echo "$HOME/.ssh/:")
$(ls -al ~/.ssh)" "$(cat << EOF
ssh-keygen
EOF
)"

next "$(cat << EOF
sudo apt install -y synaptic
sudo apt install -y net-tools
sudo apt install -y gnome-tweaks
sudo apt install -y gnome-screenshot
sudo apt install -y ranger
sudo apt install -y ueberzug
EOF
)"

next "$(cat << EOF
sudo apt install -y vim
sudo apt install -y vim-gtk3
sudo apt install -y curl
sudo apt install -y xsel
sudo apt install -y tmux
sudo apt install -y terminator
sudo apt install -y sqlitebrowser
sudo snap install intellij-idea-ultimate --classic
sudo snap install sublime-text --classic
sudo snap install code --classic
EOF
)"

next "$(cat << EOF
sudo apt install -y build-essential
sudo apt install -y linux-headers-generic
EOF
)"

next_warned "[!] Please make sure that the VMware-Workstation installer is downloaded beforehand 
# --> https://www.perforce.com/products/helix-core-apps/merge-diff-tool-p4merge" "$(cat << EOF
sudo find ~/Downloads -name 'VMware*.bundle' -print  -exec chmod +x {} \; -exec {} \;
EOF
)"

next_warned "[!] Please make sure that the P4V archive is downloaded beforehand 
# --> https://www.perforce.com/products/helix-core-apps/merge-diff-tool-p4merge" "$(cat << EOF
ARC_PATH=\$(find ~/Downloads -name p4v.tgz)
ARC_ROOT=\$(tar -tf \$ARC_PATH | head -n 1)
mkdir -p /truman/tools/p4v/ && tar -xf \$ARC_PATH -C /truman/tools/p4v/ && ln -s /truman/tools/p4v/\$ARC_ROOT /truman/tools/p4v/current && sudo apt install libxcb-cursor0
EOF
)"

echo "Done!!!"

exit 0

# Tester
next "$(cat << EOF
EOF
)"

next "$(cat << EOF
echo hi
echo hi2
echo hi3
sleep 3s
echo Done!
echo "Hello, world!_ :: foo()"
echo 'Bye bye'
EOF
)"
