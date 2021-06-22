# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-gui-vnc-vm
# ==================
##

/rw/config/rc.local:
  file.append:
    - text: |
        sudo usermod -p '{{ salt['pillar.get']('qvm:sys-gui-vnc-vm:password-hash', '!') }}' user
