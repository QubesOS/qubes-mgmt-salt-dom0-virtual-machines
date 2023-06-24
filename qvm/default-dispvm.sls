# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.default-dispvm
# ========
#
# Installs default DispVM template: default-dvm AppVM unless configured otherwise.
#
# Execute:
#   qubesctl state.sls qvm.default-dispvm dom0
##

{% set gui_user = salt['cmd.shell']('groupmems -l -g qubes') %}
{% set default_template = salt['cmd.shell']('qubes-prefs default-template') %}

default-dvm:
  qvm.vm:
   - present:
     - label: red
   - prefs:
     - label: red
     - dispvm-allowed: True
   - features:
     - enable:
       - appmenus-dispvm

# Handle org.gnome.Terminal, xfce4-terminal, and xterm, as well as firefox vs firefox-esr
qvm-appmenus --get-default-whitelist {{default_template}} | grep -i 'firefox\|term' | qvm-appmenus --set-whitelist=- --update default-dvm:
  cmd.run:
    - runas: {{ gui_user }}
    - requires:
      - qvm: default-dvm
