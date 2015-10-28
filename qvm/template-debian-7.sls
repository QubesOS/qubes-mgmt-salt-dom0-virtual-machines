# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.template-debian-7
# ======================
#
# Installs 'debian-7' template.
#
# Execute:
#   qubesctl state.sls qvm.template-debian-7 dom0
##

template-debian-7:
  pkg.installed:
    - name:     qubes-template-debian-7
    - fromrepo: qubes-templates-itl
