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

{% import "qvm/whonix.jinja" as whonix -%}

template-whonix-ws-{{ whonix.whonix_version }}:
  qvm.template_installed:
    - name:     whonix-ws-{{ whonix.whonix_version }}
    - fromrepo: {{ whonix.whonix_repo }}

whonix-ws-tag:
  qvm.vm:
    - name: whonix-ws-{{ whonix.whonix_version }}
    - tags:
      - present:
        - whonix-updatevm
    - features:
      - enable:
        - whonix-ws

whonix-ws-update-policy:
  file.prepend:
    - name: /etc/qubes/policy.d/50-config-updates.policy
    - text:
      - qubes.UpdatesProxy * @tag:whonix-updatevm @default allow,target=sys-whonix
      - qubes.UpdatesProxy * @tag:whonix-updatevm @anyvm deny
