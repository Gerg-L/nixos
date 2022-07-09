#!/usr/bin/env bash

rofi_command="rofi -theme $HOME/.config/rofi/powermenu/powermenu.rasi -p "power""

#### Options ###
power_off="襤 "
reboot="勒 "
lock=" "
suspend=" "
log_out="﫼 "
# Variable passed to rofi
options="$power_off\n$reboot\n$suspend\n$log_out"

chosen="$(echo -e "$options" | $rofi_command -dmenu -selected-row 2)"
case $chosen in
    $power_off)
        systemctl poweroff
        ;;
    $reboot)
        systemctl reboot
        ;;
    $suspend)
	systemctl suspend
        ;;
    $log_out)
        bspc quit
        ;;
esac
