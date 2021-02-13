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

  whonix-gw:
    prefs:
      - netvm:     test-sys-whonix
    require:
      - pkg:       template-whonix-gw
      - qvm:       test-sys-whonix

  whonix-ws:
    prefs:
      - netvm:     test-sys-whonix
    require:
      - pkg:       template-whonix-ws
      - qvm:       test-sys-whonix

  sys-whonix:
    name:          test-sys-whonix
    #present:
    #  - template:  whonix-gw
    #  - label:     yellow
    #  - mem:       600
    #  - flags:
    #    - proxy
    require:
      - pkg:       template-whonix-gw
      - qvm:       test-sys-firewall

  anon-whonix:
    name:          test-anon-whonix
    prefs:
      - netvm:     test-sys-whonix
    require:
      - pkg:       template-whonix-ws
      - qvm:       test-sys-whonix

  work:
    name:          test-work
    require:
      - pkg:       template-fedora-33
      - qvm:       test-sys-firewall

  personal:
    name:          test-personal
    require:
      - pkg:       template-fedora-33
      - qvm:       test-sys-firewall

  untrusted:
    name:          test-untrusted
    require:
      - pkg:       template-fedora-33
      - qvm:       test-sys-firewall

  vault:
    name:          test-vault
    require:
      - pkg:       template-fedora-33

  sys-net:
    name:          test-sys-net
    require:
      - pkg:       template-fedora-33

  sys-firewall:
    name:          test-sys-firewall
    require:
      - pkg:       template-fedora-33
      - qvm:       test-sys-net
