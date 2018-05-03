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
  - qvm.whonix-ws-dvm

{%- from "qvm/whonix.jinja" import whonix with context -%}
{%- from "qvm/template.jinja" import load -%}

{% load_yaml as defaults -%}
name:          anon-whonix
present:
  - template:  whonix-ws-{{ whonix.whonix_version }}
  - label:     red
prefs:
  - netvm:     sys-whonix
  - default-dispvm: whonix-ws-dvm
tags:
  - add:
    - anon-vm
require:
  - pkg:       template-whonix-ws-{{ whonix.whonix_version }}
  - qvm:       sys-whonix
  - qvm:       whonix-ws-{{ whonix.whonix_version }}-dvm
{%- endload %}

{{ load(defaults) }}
