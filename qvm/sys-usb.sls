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

{% from "qvm/template.jinja" import load -%}

# Avoid duplicated states
{% if salt['pillar.get']('qvm:sys-usb:name', 'sys-usb') != salt['pillar.get']('qvm:sys-net:name', 'sys-net') %}

{% load_yaml as defaults -%}
name:          sys-usb
present:
  - label:     red
  - mem:       300
  - flags:
    - net
prefs:
  - netvm:     ""
  - virt_mode: hvm
  - autostart: true
  - pcidevs:   {{ salt['grains.get']('pci_usb_devs', [])|yaml }}
  - pci_strictreset: false
service:
  - disable:
    - network-manager
    - meminfo-writer
{%- endload %}

{{ load(defaults) }}

{% else %}

{% set vmname = salt['pillar.get']('qvm:sys-net:name', 'sys-net') %}

{{ vmname }}-usb:
  qvm.prefs:
    - name: {{ vmname }}
    - pcidevs: {{ salt['grains.get']('pci_net_devs', []) + salt['grains.get']('pci_usb_devs', []) }}
    - pci_strictreset: False
    - require:
      - sls: qvm.sys-net

{% endif %}

qubes-input-proxy:
  pkg.installed: []

# Setup Qubes RPC policy
sys-usb-input-proxy:
  file.prepend:
    - name: /etc/qubes-rpc/policy/qubes.InputMouse
    - text: {{ salt['pillar.get']('qvm:sys-usb:name', 'sys-usb') }} dom0 allow,user=root
    - require:
      - pkg:       qubes-input-proxy
