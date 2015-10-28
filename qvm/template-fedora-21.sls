# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.template-fedora-21
# ======================
#
# Installs 'fedora-21' template.
#
# Execute:
#   qubesctl state.sls qvm.template-fedora-21 dom0
##

template-fedora-21:
  pkg.installed:
    - name:     qubes-template-fedora-21
    - fromrepo: qubes-templates-itl
