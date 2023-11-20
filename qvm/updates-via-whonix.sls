# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.updates-via-whonix
# ===============
#
# Upgrade all TemplateVMs through sys-whonix.
# Setup UpdatesProxy to always use sys-whonix for all TemplateVMs.
#
# Execute:
#   qubesctl state.sls qvm.updates-via-whonix dom0
##


default-update-policy-whonix:
  file.prepend:
    - name: /etc/qubes/policy.d/50-config-updates.policy
    - text:
      - qubes.UpdatesProxy * @type:TemplateVM @default allow target=sys-whonix
