# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-usb
# ===========
#
# Installs 'sys-usb' UsbVM.
#
# Pillar data will also be merged if available within the ``qvm`` pillar key:
#   ``qvm:sys-usb``
#
# located in ``/srv/pillar/dom0/qvm/init.sls``
#
# Execute:
#   qubesctl state.sls qvm.sys-usb dom0
##

include:
  - qvm.hide-usb-from-dom0

{%- from "qvm/template.jinja" import load -%}

{% load_yaml as defaults -%}
name:          sys-usb
present:
  - label:     red
  - mem:       300
  - flags:
    - net
prefs:
  - netvm:     ""
  - autostart: true
  - pcidevs:   {{ salt['grains.get']('pci_usb_devs', []) }}
  - pci_strictreset: false
service:
  - disable:
    - network-manager
{%- endload %}

{{ load(defaults) }}

qubes-input-proxy:
  pkg.installed: []

# Setup Qubes RPC policy
sys-usb-input-proxy:
  file.prepend:
    - name: /etc/qubes-rpc/policy/qubes.InputMouse
    - text: sys-usb dom0 allow,user=root
    - require:
      - pkg:       qubes-input-proxy
