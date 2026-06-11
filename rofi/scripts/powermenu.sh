#!/usr/bin/env bash

# Options
shutdown='<> Shutdown'
reboot='() Reboot'
lock='/ Lock'
suspend='X Suspend'
logout='< Logout'
yes='✔ Yes'
no='✗ No'

# Rofi Command
rofi_command="rofi -dmenu -i -p 'Session' -theme ~/.config/rofi/powermenu.rasi"

# Confirmation
confirm_exit() {
	echo -e "$yes\n$no" | rofi -dmenu\
		-i\
		-no-fixed-num-lines\
		-p "Are You Sure?"\
		-theme ~/.config/rofi/confirm.rasi
}

# Variable passed to rofi
options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"

chosen="$(echo -e "$options" | $rofi_command)"
case $chosen in
    $shutdown)
		ans=$(confirm_exit &)
		if [[ $ans == "$yes" ]]; then
			systemctl poweroff
		elif [[ $ans == "$no" ]]; then
			exit 0
        fi
        ;;
    $reboot)
		ans=$(confirm_exit &)
		if [[ $ans == "$yes" ]]; then
			systemctl reboot
		elif [[ $ans == "$no" ]]; then
			exit 0
        fi
        ;;
    $lock)
		if [[ -f /usr/bin/betterlockscreen ]]; then
			betterlockscreen -l
		elif [[ -f /usr/bin/i3lock ]]; then
			i3lock
		fi
        ;;
    $suspend)
		ans=$(confirm_exit &)
		if [[ $ans == "$yes" ]]; then
			mpc -q pause
			amixer set Master mute
			systemctl suspend
		elif [[ $ans == "$no" ]]; then
			exit 0
        fi
        ;;
    $logout)
		ans=$(confirm_exit &)
		if [[ $ans == "$yes" ]]; then
			if [[ "$DESKTOP_SESSION" == "i3" ]]; then
				i3-msg exit
			elif [[ "$DESKTOP_SESSION" == "bspwm" ]]; then
				bspc quit
			elif [[ "$DESKTOP_SESSION" == "plasma" ]]; then
				qdbus org.kde.ksmserver /KSMServer logout 0 0 0
			else
				loginctl terminate-session ${XDG_SESSION_ID-}
			fi
		elif [[ $ans == "$no" ]]; then
			exit 0
        fi
        ;;
esac
