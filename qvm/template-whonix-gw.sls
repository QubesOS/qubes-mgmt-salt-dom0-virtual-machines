# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.template-whonix-gw
# ======================
#
# Installs 'whonix-gw' template.
#
# Execute:
#   qubesctl state.sls qvm.template-whonix-gw dom0
##

{% import "qvm/whonix.jinja" as whonix -%}

template-whonix-gw-{{ whonix.whonix_version }}:
  qvm.template_installed:
    - name:     whonix-gw-{{ whonix.whonix_version }}
    - fromrepo: {{ whonix.whonix_repo }}

whonix-gw-tag:
  qvm.vm:
    - name: whonix-gw-{{ whonix.whonix_version }}
    - tags:
      - present:
        - whonix-updatevm
    - features:
      - enable:
        - whonix-gw

whonix-gw-update-policy:
  file.prepend:
    - name: /etc/qubes/policy.d/50-config-updates.policy
    - text:
      - qubes.UpdatesProxy * @tag:whonix-updatevm @default allow,target=sys-whonix
      - qubes.UpdatesProxy * @tag:whonix-updatevm @anyvm deny
