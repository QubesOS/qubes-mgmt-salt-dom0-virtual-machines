# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-gui-vm
# ==============
##

{% set user = salt['cmd.run']('qubesdb-read /default-user') or 'user' %}
{% set home = salt['user.info'](user).get('home') or '/home/' ~ user %}
{% for autostart in ['nm-applet'] %}
{{ home }}/.config/autostart/{{autostart}}.desktop:
  file.managed:
    - user: {{ user }}
    - mode: 640
    - makedirs: True
    - contents: |
        [Desktop Entry]
        Hidden=true
{% endfor %}
