# editor
alias v="nvim"
alias nv="nvim"
alias vm="NVIM_MINIMAL=YES nvim"

# system stuff
alias status="systemctl status"
alias syslogs="journalctl -fu"

# git
alias gs="git status"
alias gf="git fetch --all"
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit -m "[WIP]: $(date)"'
alias gundo="git reset HEAD~"
alias gcm="git-credential-manager"
alias gl="git log --pretty=format:'%C(yellow)%h%Cred%d - %Creset%s%Cblue - [%cn]' --decorate"
alias gll="git log --pretty=format:'%C(yellow)%h%Cred%d - %Creset%s%Cblue - [%cn]' --decorate --numstat"
alias gc="git commit"
alias gpr="git pull --rebase"
alias gpl="git pull"
alias gps="git push"
alias gd="git diff"
alias ga="git add"
alias gsub="git submodule"
alias glines="git ls-files | xargs wc -l"

# chezmoi
alias cz="chezmoi"
alias cze="chezmoi edit"
alias cza="chezmoi apply"

# apt
alias agi="sudo apt-get install "

# finding
alias p="ps aux | grep -i "
alias h="history | grep -i "
alias diskspace="du -S | sort -nr | more"

# list
alias ls="ls --color"
alias ll="ls -al"
alias la="ls -A"
alias l="ls"

# keyboard
alias kger="setxkbmap de"
alias kus="setxkbmap us"

alias ..="cd .."
alias c="cd"

# sound
alias vol="amixer set Master --quiet"
alias mute="amixer set Master 1+ toggle --quiet"

# media
alias stitle="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:Metadata | sed -n '/title/{n;p}' | cut -d '\"' -f 2"
alias snext="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next > /dev/null && stitle"
alias sstate="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' | grep -oE '(Playing|Paused)'"
alias sn=snext
alias spause="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause > /dev/null"
alias stoggle="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause > /dev/null"
alias splay="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play > /dev/null"
alias srep="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Repeat > /dev/null && echo 'repeating stitle'"
alias sprev="dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous > /dev/null && stitle"
alias sp=sprev
alias yt="mpv --ytdl-raw-options='cookies=$HOME/Downloads/yt_cookies.txt'"

# browser & programs
alias bt="blueman-manager&"
alias draw="brave-browser excalidraw.com&"

# system
alias lock="dm-tool lock"
alias o="xdg-open"
set_brightness() {
	xrandr --output eDP --brightness $1
}
alias brightness="set_brightness"
alias ram="free -h --si"
mirror_monitors() {
	xrandr --output $1 --auto --same-as $2
}
alias mirror="mirror_monitors"
alias vpn="/opt/cisco/secureclient/bin/vpnui"
alias ts="~/.local/bin/tmux-sessionizer.sh"
alias tmux="tmux -2"
alias sa="eval $(ssh-agent)"
