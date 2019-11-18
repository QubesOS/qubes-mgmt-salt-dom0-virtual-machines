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
  - template:  {{ salt['pillar.get']('qvm:sys-audio:template', 'fedora-30-xfce') }}
{%- endload %}

{{ load(defaults) }}

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

{% endif %}