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
  pkg.installed:
    - name:     qubes-template-whonix-ws-{{ whonix.whonix_version }}
    - fromrepo: qubes-templates-community
