# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.personal
# ============
#
# Installs 'personal' AppVM.
#
# Pillar data will also be merged if available within the ``qvm`` pillar key:
#   ``qvm:personal``
#
# located in ``/srv/pillar/dom0/qvm/init.sls``
#
# Execute:
#   qubesctl state.sls qvm.personal dom0
##

include:
  - qvm.template-fedora-21
  - qvm.sys-firewall

{%- from "qvm/template.jinja" import load -%}

{% load_yaml as defaults -%}
name:         personal
present:
  - template: fedora-21
  - label:    yellow
prefs:
  - netvm:    sys-firewall
require:
  - pkg:      template-fedora-21
  - qvm:      sys-firewall
{%- endload %}

{{ load(defaults) }}
