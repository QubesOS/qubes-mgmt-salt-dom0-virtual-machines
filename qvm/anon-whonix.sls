# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.anon-whonix
# ===============
#
# Installs 'anon-whonix' AppVM.
#
# Pillar data will also be merged if available within the ``qvm`` pillar key:
#   ``qvm:anon-whonix``
#
# located in ``/srv/pillar/dom0/qvm/init.sls``
#
# Execute:
#   qubesctl state.sls qvm.anon-whonix dom0
##

include:
  - qvm.template-whonix-ws
  - qvm.sys-whonix

{%- from "qvm/template.jinja" import load -%}

{% load_yaml as defaults -%}
name:          anon-whonix
present:
  - template:  whonix-ws
  - label:     red
prefs:
  - netvm:     sys-whonix
require:
  - pkg:       template-whonix-ws
  - qvm:       sys-whonix
{%- endload %}

{{ load(defaults) }}

{% load_yaml as template -%}
name:          whonix-ws
force:         true
prefs:
  - netvm:     sys-whonix
require:
  - pkg:       template-whonix-ws
  - qvm:       sys-whonix
{%- endload %}

{{ load(template) }}
