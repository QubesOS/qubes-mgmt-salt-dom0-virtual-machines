# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-firewall
# ================
#
# Installs 'sys-firewall' ProxyVM.
#
# Pillar data will also be merged if available within the ``qvm`` pillar key:
#   ``qvm:sys-firewall``
#
# located in ``/srv/pillar/dom0/qvm/init.sls``
#
# Execute:
#   qubesctl state.sls qvm.sys-firewall dom0
##

{% set default_template = salt['cmd.shell']('qubes-prefs default-template') %}

include:
  {% if salt['pillar.get']('qvm:sys-firewall:disposable', false) %}
  - qvm.default-dispvm
  {% endif %}
  - qvm.sys-net

{%- from "qvm/template.jinja" import load -%}

{% load_yaml as defaults -%}
name:          sys-firewall
present:
  {% if salt['pillar.get']('qvm:sys-firewall:disposable', false) %}
  - class:     DispVM
  - template:  default-dvm
  {% endif %}
  - label:     green
prefs:
  - netvm:     sys-net
  - autostart: true
  - provides-network: true
  - memory:       500
require:
  {% if salt['pillar.get']('qvm:sys-firewall:disposable', false) %}
  - qvm:       default-dvm
  {% endif %}
  - qvm:       sys-net
{%- endload %}

{{ load(defaults) }}
