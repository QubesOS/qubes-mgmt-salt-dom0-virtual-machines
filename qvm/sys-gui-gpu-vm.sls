# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-gui-gpu-vm
# ===========
##

/home/user/.config/autostart/qvm-start-daemon.desktop:
  file.managed:
    - user: user
    - mode: 640
    - makedirs: True
    - contents: |
        [Desktop Entry]
        Name=Qubes Guid/Pacat
        Comment=Starts GUI/AUDIO daemon for Qubes VMs
        Icon=qubes
        Exec=qvm-start-daemon --all --watch
        Terminal=false
        Type=Application

/rw/config/rc.local:
  file.append:
    - text: |
        sudo usermod -p '{{ salt['pillar.get']('qvm:sys-gui-gpu-vm:password-hash', '!') }}' user
