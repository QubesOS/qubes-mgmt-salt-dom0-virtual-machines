# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-audio-vm
# ==============
##

# WIP: currently use default user 'user'
/home/user/.config/autostart/qubes-pulseaudio.desktop:
  file.managed:
    - user: user
    - mode: 640
    - makedirs: True
    - contents: |
        [Desktop Entry]
        Hidden=true