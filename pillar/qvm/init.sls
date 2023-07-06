# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

# pillar

# NOTE:
#   - The following pillar data is used only for development testing which is
#     used to override any defualts set within the states which are located in
#     the ``/srv/formulas/dom0/virtual-machines/qvm`` directory.
#
#   - Change ``qvm-disabled`` to ``qvm`` to enable the pillar overrides.
qvm-disabled:
  # Enabling debug mode reports all results in salt hightstate comment message
  # compared to the default of only the last result message.
  debug: true
  force: true

  whonix-gateway:
    prefs:
      - netvm:     test-sys-whonix
    require:
      - qvm:       template-whonix-gateway
      - qvm:       test-sys-whonix

  whonix-workstation:
    prefs:
      - netvm:     test-sys-whonix
    require:
      - qvm:       template-whonix-workstation
      - qvm:       test-sys-whonix

  sys-whonix:
    name:          test-sys-whonix
    #present:
    #  - template:  whonix-gateway
    #  - label:     yellow
    #  - mem:       600
    #  - flags:
    #    - proxy
    require:
      - qvm:       template-whonix-gateway
      - qvm:       test-sys-firewall

  anon-whonix:
    name:          test-anon-whonix
    prefs:
      - netvm:     test-sys-whonix
    require:
      - qvm:       template-whonix-workstation
      - qvm:       test-sys-whonix

  work:
    name:          test-work
    require:
      - qvm:       template-fedora-37
      - qvm:       test-sys-firewall

  personal:
    name:          test-personal
    require:
      - qvm:       template-fedora-37
      - qvm:       test-sys-firewall

  untrusted:
    name:          test-untrusted
    require:
      - qvm:       template-fedora-37
      - qvm:       test-sys-firewall

  vault:
    name:          test-vault
    require:
      - qvm:       template-fedora-37

  sys-net:
    name:          test-sys-net
    require:
      - qvm:       template-fedora-37

  sys-firewall:
    name:          test-sys-firewall
    require:
      - qvm:       template-fedora-37
      - qvm:       test-sys-net
