# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.template-whonix-ws
# ======================
#
# Installs 'whonix-ws' template.
#
# Execute:
#   qubesctl state.sls qvm.template-whonix-ws dom0
##

{%- from "qvm/whonix.jinja" import whonix with context -%}

template-whonix-ws-{{ whonix.whonix_version }}:
  pkg.installed:
    - name:     qubes-template-whonix-ws-{{ whonix.whonix_version }}
    - fromrepo: qubes-templates-community

whonix-ws-tag:
  qvm.vm:
    - name: whonix-ws-{{ whonix.whonix_version }}
    - tags:
      - present:
        - whonix-updatevm
    - features:
      - enable:
        - whonix-ws-{{ whonix.whonix_version }}

whonix-ws-update-policy:
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
