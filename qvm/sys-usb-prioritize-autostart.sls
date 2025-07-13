# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-usb-prioritize-autostart
# ================================
#
# Prioritize sys-usb startup before login and other autostarted VMs.
#
# Execute:
#   qubesctl state.sls qvm.sys-usb-prioritize-autostart
##

/etc/systemd/system/qubes-vm@{{ salt['pillar.get']('qvm:sys-usb:name', 'sys-usb') }}.service.d/50_autostart.conf:
  file.managed:
    - contents: |
        [Unit]
        Before=systemd-user-sessions.service
    - makedirs: True

/etc/systemd/system/qubes-vm@.service.d/50_autostart.conf:
  file.managed:
    - contents: |
        [Unit]
        After=qubes-vm@{{ salt['pillar.get']('qvm:sys-usb:name', 'sys-usb') }}.service
    - makedirs: True
