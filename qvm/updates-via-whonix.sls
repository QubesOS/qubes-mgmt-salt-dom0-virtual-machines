# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.updates-via-whonix
# ===============
#
# Setup UpdatesProxy to always use sys-whonix.
#
# Execute:
#   qubesctl state.sls qvm.updates-via-whonix dom0
##


default-update-policy-whonix:
  file.prepend:
    - name: /etc/qubes-rpc/policy/qubes.UpdatesProxy
    - text:
      - $type:TemplateVM $default allow,target=sys-whonix
