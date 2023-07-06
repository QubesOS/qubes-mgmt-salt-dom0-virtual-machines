# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.template-whonix-workstation
# ======================
#
# Installs 'whonix-workstation' template.
#
# Execute:
#   qubesctl state.sls qvm.template-whonix-workstation dom0
##

{% import "qvm/whonix.jinja" as whonix -%}

template-whonix-workstation-{{ whonix.whonix_version }}:
  qvm.template_installed:
    - name:     whonix-workstation-{{ whonix.whonix_version }}
    - fromrepo: {{ whonix.whonix_repo }}

whonix-workstation-tag:
  qvm.vm:
    - name: whonix-workstation-{{ whonix.whonix_version }}
    - tags:
      - present:
        - whonix-updatevm
    - features:
      - enable:
        - whonix-ws

whonix-workstation-update-policy:
  file.prepend:
    - name: /etc/qubes-rpc/policy/qubes.UpdatesProxy
    - text:
      - $tag:whonix-updatevm $default allow,target=sys-whonix
      - $tag:whonix-updatevm $anyvm deny

# this is for whonix-ws based VMs
whonix-get-date-policy:
  file.prepend:
    - name: /etc/qubes-rpc/policy/qubes.GetDate
    - text:
      - $tag:anon-vm $anyvm deny
