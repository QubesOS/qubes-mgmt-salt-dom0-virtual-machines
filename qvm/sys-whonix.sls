# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-whonix
# ==============
#
# Installs 'sys-whonix' ProxyVM.
#
# Pillar data will also be merged if available within the ``qvm`` pillar key:
#   ``qvm:sys-whonix``
#
# located in ``/srv/pillar/dom0/qvm/init.sls``
#
# Execute:
#   qubesctl state.sls qvm.sys-whonix dom0
##

include:
  - qvm.template-whonix-gw
  - qvm.sys-firewall

{%- from "qvm/whonix.jinja" import whonix with context -%}
{%- from "qvm/template.jinja" import load -%}

{% load_yaml as defaults -%}
name:          sys-whonix
present:
  - template:  whonix-gw-{{ whonix.whonix_version }}
  - label:     black
  - mem:       500
prefs:
  - netvm:     sys-firewall
  - provides-network: true
  - autostart: true
require:
  - pkg:       template-whonix-gw-{{ whonix.whonix_version }}
  - qvm:       sys-firewall
{%- endload %}

{{ load(defaults) }}

