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
  - qvm.template-whonix-workstation
  - qvm.sys-whonix
  - qvm.whonix-workstation-dvm

{%- import "qvm/whonix.jinja" as whonix -%}
{%- from "qvm/template.jinja" import load -%}

{% load_yaml as defaults -%}
name:          anon-whonix
present:
  - template:  whonix-workstation-{{ whonix.whonix_version }}
  - label:     red
prefs:
  - netvm:     sys-whonix
  - default-dispvm: whonix-workstation-{{ whonix.whonix_version }}-dvm
tags:
  - add:
    - anon-vm
require:
  - qvm:       template-whonix-workstation-{{ whonix.whonix_version }}
  - qvm:       sys-whonix
  - qvm:       whonix-workstation-{{ whonix.whonix_version }}-dvm
{%- endload %}

{{ load(defaults) }}
