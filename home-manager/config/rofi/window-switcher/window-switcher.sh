#!/usr/bin/env bash
path=$HOME/.config/rofi/window-switcher/box.rasi
windows="$(xprop -root _NET_CLIENT_LIST | grep -o '0x' | wc -l )"
if (($windows<8)); then
    width=$(($windows*150))
else
    width=1200
fi
rofi \
    -no-lazy-grab \
    -show window \
    -theme $path \
    -theme-str 'window {width: '$width';}'
