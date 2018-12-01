# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.default-mgmt-dvm
# ====================
#
# Installs default management DispVM template: default-mgmt-dvm AppVM.
#
# Execute:
#   qubesctl state.sls qvm.default-mgmt-dvm dom0
##

default-mgmt-dvm:
  qvm.vm:
   - present:
     - label: black
   - prefs:
     - label: black
     - netvm: ""
     - dispvm-allowed: True
   - features:
     - enable:
       - appmenus-dispvm
       - internal

qubes-prefs management_dispvm default-mgmt-dvm:
  cmd.run: []
