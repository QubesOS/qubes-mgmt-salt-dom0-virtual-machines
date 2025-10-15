# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-audio
# ===========
##

{% from "qvm/template.jinja" import load -%}

{% if salt['pillar.get']('qvm:sys-audio:name', 'sys-audio') != salt['pillar.get']('qvm:sys-gui:name', 'sys-gui') %}

{% set vmname = salt['pillar.get']('qvm:sys-audio:name', 'sys-audio') %}

{% load_yaml as defaults -%}
name:          sys-audio
present:
  - label:     black
  - mem:       400
prefs:
  - netvm:     ""
  - virt_mode: hvm
  - autostart: true
  - pci_strictreset: false
  - pcidevs:   {{ salt['grains.get']('pci_audio_devs', [])|yaml }}
  - template:  {{ salt['pillar.get']('qvm:sys-audio:template', 'fedora-42-xfce') }}
features:
  - enable:
    - servicevm
service:
  - enable:
    - audiovm
{%- endload %}

{{ load(defaults) }}

# Setup Qubes RPC policy for sys-audio
# If sys-audio is sys-gui it's not needed
# as sys-gui is a admin-global-rwx
sys-audio-rpc:
  file.managed:
    - name: /etc/qubes/policy.d/50-sys-audio.policy
    - contents: |
        admin.Events          *   sys-audio     sys-audio               allow   target=dom0
        admin.Events          *   sys-audio     @adminvm                allow   target=dom0
        admin.Events          *   sys-audio     @tag:audiovm-sys-audio  allow   target=dom0
        admin.vm.CurrentState *   sys-audio     sys-audio               allow   target=dom0
        admin.vm.CurrentState *   sys-audio     @adminvm                allow   target=dom0
        admin.vm.CurrentState *   sys-audio     @tag:audiovm-sys-audio  allow   target=dom0
        admin.vm.List         *   sys-audio     sys-audio               allow   target=dom0
        admin.vm.List         *   sys-audio     @adminvm                allow   target=dom0
        admin.vm.List         *   sys-audio     @tag:audiovm-sys-audio  allow   target=dom0
        admin.vm.property.Get               +audiovm sys-audio     @tag:audiovm-sys-audio  allow   target=dom0
        admin.vm.property.Get               +xid     sys-audio     @tag:audiovm-sys-audio  allow   target=dom0
        admin.vm.property.Get               +stubdom_xid     sys-audio     @tag:audiovm-sys-audio  allow   target=dom0
        admin.vm.property.Get               +virt_mode     sys-audio     @tag:audiovm-sys-audio  allow   target=dom0
        admin.vm.feature.CheckWithTemplate  +audio   sys-audio     @tag:audiovm-sys-audio  allow   target=dom0
        admin.vm.feature.CheckWithTemplate  +audio-model   sys-audio     @tag:audiovm-sys-audio  allow   target=dom0

{% else %}

{% set vmname = salt['pillar.get']('qvm:sys-gui:name', 'sys-gui') %}

{{ vmname }}-audio:
  qvm.prefs:
    - name: {{ vmname }}
    - virt_mode: hvm
    - pcidevs:   {{ salt['grains.get']('pci_audio_devs', [])|yaml }}
    - pci_strictreset: false
# WIP: currently it's broken due to recursive loop detected
#    - require:
#      - sls: qvm.sys-gui

# AudioVM (AdminVM) with local 'ro' permissions
/etc/qubes/policy.d/include/admin-local-ro:
  file.append:
    - text: |
        {{ vmname }} @tag:audiovm-{{ vmname }} allow target=dom0
        {{ vmname }} {{ vmname }} allow target=dom0

{% endif %}
