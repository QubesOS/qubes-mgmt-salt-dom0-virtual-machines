# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.template-debian-8
# ======================
#
# Installs 'debian-8' template.
#
# Execute:
#   qubesctl state.sls qvm.template-debian-8 dom0
##

template-debian-8:
  pkg.installed:
    - name:     qubes-template-debian-8
    - fromrepo: qubes-templates-itl
