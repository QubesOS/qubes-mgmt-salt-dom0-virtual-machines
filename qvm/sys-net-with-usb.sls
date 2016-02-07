# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-net-with-usb
# ===========
#
# Bundle UsbVM functionality into 'sys-net'.
# Do not enable together with 'sys-usb' state.
#
##

include:
  - qvm.sys-net

{% set vmname = salt['pillar.get']('qvm:sys-net:name', 'sys-net') %}

{{ vmname }}-usb:
  qvm.prefs:
    - name: {{ vmname }}
    - pcidevs: {{ salt['grains.get']('pci_net_devs', []) + salt['grains.get']('pci_usb_devs', []) }}
    - pci_strictreset: False
    - require:
      - sls: qvm.sys-net

qubes-input-proxy:
  pkg.installed: []

# Setup Qubes RPC policy
sys-usb-input-proxy:
  file.prepend:
    - name: /etc/qubes-rpc/policy/qubes.InputMouse
    - text: {{ vmname }} dom0 ask,user=root
    - require:
      - pkg:       qubes-input-proxy
