# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.template-fedora-21-minimal
# ======================
#
# Installs 'fedora-21-minimal' template.
#
# Execute:
#   qubesctl state.sls qvm.template-fedora-21-minimal dom0
##

template-fedora-21-minimal:
  pkg.installed:
    - name:     qubes-template-fedora-21-minimal
    - fromrepo: qubes-templates-itl
