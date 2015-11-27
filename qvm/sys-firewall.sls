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

include:
  - qvm.sys-net

{%- from "qvm/template.jinja" import load -%}

{% load_yaml as defaults -%}
name:          sys-firewall
present:
  - label:     green
  - mem:       500
  - flags:
    - proxy
prefs:
  - netvm:     sys-net
  - autostart: true
require:
  - qvm:       sys-net
{%- endload %}

{{ load(defaults) }}
