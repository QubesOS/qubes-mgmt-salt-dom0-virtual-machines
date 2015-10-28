# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.vault
# =========
#
# Installs 'vault' AppVM.
#
# Pillar data will also be merged if available within the ``qvm`` pillar key:
#   ``qvm:vault``
#
# located in ``/srv/pillar/dom0/qvm/init.sls``
#
# Execute:
#   qubesctl state.sls qvm.vault dom0
##

include:
  - qvm.template-fedora-21

{%- from "qvm/template.jinja" import load -%}

{% load_yaml as defaults -%}
name:         vault
present:
  - template: fedora-21
  - label:    black
prefs:
  - netvm:    'none'
require:
  - pkg:      template-fedora-21
{%- endload %}

{{ load(defaults) }}
