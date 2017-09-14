# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.whonix-ws-dvm
# ===============
#
# Installs 'whonix-ws-dvm' AppVM as a base for Disposable VMs.
#
# Pillar data will also be merged if available within the ``qvm`` pillar key:
#   ``qvm:whonix-ws-dvm``
#
# located in ``/srv/pillar/dom0/qvm/init.sls``
#
# Execute:
#   qubesctl state.sls qvm.whonix-ws-dvm dom0
##

include:
  - qvm.template-whonix-ws
  - qvm.sys-whonix

{%- from "qvm/template.jinja" import load -%}

{% load_yaml as defaults -%}
name:          whonix-ws-dvm
present:
  - template:  whonix-ws
  - label:     red
prefs:
  - netvm:     sys-whonix
  - template-for-dispvms: true
  - default-dispvm: whonix-ws-dvm
tags:
  - add:
    - anon-vm
require:
  - pkg:       template-whonix-ws
  - qvm:       sys-whonix
{%- endload %}

{{ load(defaults) }}
