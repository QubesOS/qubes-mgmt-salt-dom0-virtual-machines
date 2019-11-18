# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-gui-vm
# ==============
##

# WIP: currently use default user 'user'
{% for autostart in ['xscreensaver', 'xscreensaver-autostart', 'nm-applet'] %}
/home/user/.config/autostart/{{autostart}}.desktop:
  file.managed:
    - user: user
    - mode: 640
    - makedirs: True
    - contents: |
        [Desktop Entry]
        Hidden=true
{% endfor %}