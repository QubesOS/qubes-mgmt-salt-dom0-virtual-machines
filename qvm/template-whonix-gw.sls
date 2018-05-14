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

{%- import "qvm/whonix.jinja" as whonix -%}

template-whonix-gw-{{ whonix.whonix_version }}:
  pkg.installed:
    - name:     qubes-template-whonix-gw-{{ whonix.whonix_version }}
    - fromrepo: qubes-templates-community

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
    - name: /etc/qubes-rpc/policy/qubes.UpdatesProxy
    - text:
      - $tag:whonix-updatevm $default allow,target=sys-whonix
      - $tag:whonix-updatevm $anyvm deny
