# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.whonix-workstation-dvm
# ===============
#
# Installs 'whonix-workstation-dvm' AppVM as a base for Disposable VMs.
#
# Pillar data will also be merged if available within the ``qvm`` pillar key:
#   ``qvm:whonix-workstation-dvm``
#
# located in ``/srv/pillar/dom0/qvm/init.sls``
#
# Execute:
#   qubesctl state.sls qvm.whonix-workstation-dvm dom0
##

include:
  - qvm.template-whonix-workstation
  - qvm.sys-whonix

{%- import "qvm/whonix.jinja" as whonix -%}
{%- from "qvm/template.jinja" import load -%}

{% set gui_user = salt['cmd.shell']('groupmems -l -g qubes') %}

{% load_yaml as defaults -%}
name:          whonix-workstation-{{ whonix.whonix_version }}-dvm
present:
  - template:  whonix-workstation-{{ whonix.whonix_version }}
  - label:     red
prefs:
  - netvm:     sys-whonix
  - template-for-dispvms: true
  - default-dispvm: whonix-workstation-{{ whonix.whonix_version }}-dvm
tags:
  - add:
    - anon-vm
features:
  - enable:
    - appmenus-dispvm
require:
  - qvm:       template-whonix-workstation-{{ whonix.whonix_version }}
  - qvm:       sys-whonix
{%- endload %}

qvm-appmenus --update whonix-workstation-{{ whonix.whonix_version }}-dvm:
  cmd.run:
    - runas: {{ gui_user }}
    - onchanges:
      - qvm:  whonix-workstation-{{ whonix.whonix_version }}-dvm

{{ load(defaults) }}
