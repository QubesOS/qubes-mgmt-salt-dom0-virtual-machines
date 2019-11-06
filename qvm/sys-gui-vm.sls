# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-gui-vm
# ==============
##

# WIP: currently use default user 'user'
/home/user/.config/autostart/xscreensaver.desktop:
  file.managed:
    - user: user
    - mode: 640
    - makedirs: True
    - contents: |
        [Desktop Entry]
        Hidden=true

/home/user/.config/autostart/xscreensaver-autostart.desktop:
  file.managed:
    - user: user
    - mode: 640
    - makedirs: True
    - contents: |
        [Desktop Entry]
        Hidden=true