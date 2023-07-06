# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.template-whonix-gateway
# ======================
#
# Installs 'whonix-gateway' template.
#
# Execute:
#   qubesctl state.sls qvm.template-whonix-gateway dom0
##

{% import "qvm/whonix.jinja" as whonix -%}

template-whonix-gateway-{{ whonix.whonix_version }}:
  qvm.template_installed:
    - name:     whonix-gateway-{{ whonix.whonix_version }}
    - fromrepo: {{ whonix.whonix_repo }}

whonix-gateway-tag:
  qvm.vm:
    - name: whonix-gateway-{{ whonix.whonix_version }}
    - tags:
      - present:
        - whonix-updatevm
    - features:
      - enable:
        - whonix-gw

whonix-gateway-update-policy:
  file.prepend:
    - name: /etc/qubes-rpc/policy/qubes.UpdatesProxy
    - text:
      - $tag:whonix-updatevm $default allow,target=sys-whonix
      - $tag:whonix-updatevm $anyvm deny
