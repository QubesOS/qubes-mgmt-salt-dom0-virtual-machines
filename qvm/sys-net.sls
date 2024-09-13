# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-net
# ===========
#
# Installs 'sys-net' NetVM.
#
# Pillar data will also be merged if available within the ``qvm`` pillar key:
#   ``qvm:sys-net``
#
# located in ``/srv/pillar/dom0/qvm/init.sls``
#
# Execute:
#   qubesctl state.sls qvm.sys-net dom0
##

{% set default_template = salt['cmd.shell']('qubes-prefs default-template') %}

{% if salt['pillar.get']('qvm:sys-net:disposable', false) %}
include:
  - qvm.default-dispvm
{% endif %}

{%- from "qvm/template.jinja" import load -%}

{% load_yaml as defaults -%}
name:          sys-net
present:
  {% if salt['pillar.get']('qvm:sys-net:disposable', false) %}
  - class:     DispVM
  - template:  default-dvm
  {% endif %}
  - label:     red
prefs:
  - netvm:     ""
  - virt_mode: hvm
  - autostart: true
  - provides-network: true
  - memory: 425
  - pcidevs:   {{ salt['grains.get']('pci_net_devs', [])|yaml }}
service:
  - enable:
    - clocksync
  - disable:
    - meminfo-writer
{% if salt['pillar.get']('qvm:sys-net:disposable', false) %}
require:
  - qvm:       default-dvm
{% endif %}
{%- endload %}

{{ load(defaults) }}
