# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.untrusted
# =============
#
# Installs 'untrusted' AppVM.
#
# Pillar data will also be merged if available within the ``qvm`` pillar key:
#   ``qvm:untrusted``
#
# located in ``/srv/pillar/dom0/qvm/init.sls``
#
# Execute:
#   qubesctl state.sls qvm.untrusted dom0
##

include:
  - qvm.sys-firewall

{%- from "qvm/template.jinja" import load -%}

{% load_yaml as defaults -%}
name:         untrusted
present:
  - label:    red
require:
  - qvm:      sys-firewall
{%- endload %}

{{ load(defaults) }}
