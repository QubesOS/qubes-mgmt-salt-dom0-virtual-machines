#
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

qubes:
  debug: true
  defaults:
    vmnames:
      netvm: sys-net
      firewall: sys-firewall
      # XXX: Reset to normal values when testing complete
      ###whonix-gateway: sys-whonix
      whonix-gateway: sys-whonix-test

    virtual-machines:
      # XXX: Reset to normal values when testing complete
      ###sys-whonix: whonix-gateway
      ###whonix: whonix-workstation
      ###whonix-gnome: whonix-workstation-gnome

      whonix-test: whonix-workstation
      sys-whonix-test: whonix-gateway
      #whonix-gnome-test: whonix-workstation-gnome

      #sys-net: netvm
      #sys-firewall: proxyvm
      #untrusted: appvm
      #work: appvm
      #personal: appvm
