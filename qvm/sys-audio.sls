# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-audio
# ===========
##

{% from "qvm/template.jinja" import load -%}

{% load_yaml as defaults -%}
name:          sys-audio
present:
  - label:     black
  - mem:       400
prefs:
  - netvm:     ""
  - virt_mode: hvm
  - autostart: true
  - pcidevs:   {{ salt['grains.get']('pci_audio_devs', [])|yaml }}
  - template:  {{ salt['pillar.get']('qvm:sys-audio:template', 'fedora-30-xfce') }}
{%- endload %}

{{ load(defaults) }}

# Set 'sys-audio' as default AudioVM
sys-audio-default-audiovm:
  cmd.run:
    - name: qubes-prefs default_audiovm sys-audio
    - require:
      - qvm: sys-audio
