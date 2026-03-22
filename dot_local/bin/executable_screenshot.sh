#!/bin/sh
scrot $HOME/Pictures/screenshot_%b%d_%Y_%H_%M_%S.png -s -e 'xclip -selection clipboard -t image/png -i $f'
