# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-gui-gpu-vm-detach-gpu
# ===========
##

sys-gui-gpu-attach-gpu:
  qvm.devices:
    - name: sys-gui-gpu
    - detach:
      - pci:dom0:00_02.0: []
