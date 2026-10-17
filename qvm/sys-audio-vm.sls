# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-audio-vm
# ==============
##

{% set user = salt['cmd.run']('qubesdb-read /default-user') or 'user' %}
{% set home = salt['user.info'](user).get('home') or '/home/' ~ user %}
{{ home }}/.config/autostart/qubes-pulseaudio.desktop:
  file.managed:
    - user: {{ user }}
    - mode: 640
    - makedirs: True
    - contents: |
        [Desktop Entry]
        Hidden=true

{{ home }}/.config/autostart/pulseaudio.desktop:
  file.managed:
    - user: {{ user }}
    - mode: 640
    - makedirs: True
    - contents: |
        [Desktop Entry]
        Version=1.0
        Name=PulseAudio Sound System
        Comment=Start the PulseAudio Sound System
        Exec=start-pulseaudio-x11
        Terminal=false
        Type=Application