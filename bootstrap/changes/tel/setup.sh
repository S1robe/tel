UPDATE=false
WHITE=${1:-"38;5;07"}
GREEN=${1:-"38;5;02"}
RED=${1:-"38;5;01"}
log() {
	printf "\033[0;%sm%s\033[0m\033[0;%sm%s\033[0m\n" "${WHITE}" "[TEL]: " "${GREEN}" "${1}"
}
error() {
	printf "\033[0;%sm%s\033[0m\033[0;%sm%s\033[0m\n" "${WHITE}" "[TEL]: " "${RED}" "${1}"
}
if [ -f "$HOME/.tel/.installed" ]; then
    UPDATE=true
    log "updating TEL setup"
    log "updating app launcher"
else
	log "finishing TEL setup"
	log "installing required packages"
	pkg install fzf byobu curl wget nano tmux zsh ncurses-utils python jq pip neofetch git make -y
	pip install colored lolcat
	log "installing app launcher"
fi

cd ~
git clone https://github.com/t-e-l/tel-app-launcher
cd tel-app-launcher
make install
cd ~
rm -rf tel-app-launcher

#echo "/data/data/com.termux/files/usr/bin/tel-appcache" >> ~/../usr/var/lib/dpkg/info/termux-tools.list
#echo "92a2c39cbbde0f366887d99a76358852  data/data/com.termux/files/usr/bin/tel-appcache" >> ~/../usr/var/lib/dpkg/info/termux-tools.md5sums
#idk if this is necessary

app -u
mkdir -p ~/.byobu
mkdir -p ~/.termux
mkdir -p ~/.tel

if [ "$UPDATE" = false ]; then

	log "installing OhMyZsh"
	error "if you enable zsh, type 'exit' to finish setup."
	log "hit ENTER to continue"
	read blazeit
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	sed -i 's/robbyrussell/avit/g' ~/.zshrc
	echo "\n\n\n### TEL STUFF ###\n set -K # disables ! events in zsh to allow for bangs in Duckduckgo searches\nsource ~/.tel/.dev/.tel_aliases\nsource ~/.envvar # User custom ENV vars\nsource ~/.aliases # User custom Aliases\n\n\n# Example Startup Scripts\n#tel-fetch --source ~/.tel/usr/asciiart.txt\ncat ~/../usr/etc/motd\n#cmatrix -s\n#neofetch -L | lolcat -a -p 40 -s 200\n#clear" >> ~/.zshrc

	log "installing configs"
	cp -r ~/../usr/tel/.byobu/* ~/.byobu/
	cp -r ~/../usr/tel/.termux/* ~/.termux/
	cp -r ~/../usr/tel/.tel/* ~/.tel/
fi

cd ~
log "updating configs"

error "updating configs. type 'no' to skip (not recommend)"
read byobu
if [ ! "$byobu" = "no" ]; then
	cp -r ~/../usr/tel/.byobu/* ~/.byobu/
	cp -r ~/../usr/tel/.termux/* ~/.termux/
	cp -r ~/../usr/tel/.tel/* ~/.tel/
fi

log "updating permissions"

chmod +x ~/.tel/status.sh
chmod +x ~/../usr/bin/tel-applist
chmod +x ~/../usr/bin/tel-setup

if [ -f "$HOME/../usr/etc/motd_finished" ]; then
	mv ~/../usr/etc/motd_finished ~/../usr/etc/motd
fi

touch ~/.tel/.installed

log "final step: hit 'byobu-enable'"
log "after that, hit 'exit' and restart the app!"
log "if the layout is still missing, hit 'byobu-enable' and 'exit' again!"
