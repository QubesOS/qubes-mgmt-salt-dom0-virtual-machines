#!yamlscript
#
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

# TODO:
# ==============================================================================
#
# - Add other template states
# - Add pre/post hook.  sys-net to add network; whonix to add gw to templates
# - User overrides... check for same pillar in user_pillars and use it over
#   any in here... so if only whonix override exists, the rest still pull from
#   here

virtual-machines:
  whonix-gateway:
    pkg:
      name: qubes-template-whonix-gw-experimental
      fromrepo: qubes-templates-community
    #pre: {}
    vm:
      present:
        - template:  whonix-gw-experimental
        - label:     purple
        - mem:       500
        - flags:
          - proxy
      prefs:
        - action:    set
        - netvm:     $pillar('qubes:defaults:vmnames:firewall')
        - autostart: false
      service:
        - enable:
          - whonix-tor-enable
    #post: {}

  whonix-workstation:
    pkg:
      name: qubes-template-whonix-ws
      fromrepo: qubes-templates-community
    #pre: {}
    vm:
      present:
        - template:  whonix-ws
        - label:     purple
      prefs:
        - action:    set
        - netvm:     $pillar('qubes:defaults:vmnames:whonix-gateway')
        - autostart: false
      require:
        - qvm: $pillar('qubes:defaults:vmnames:whonix-gateway')
    #post: {}

  whonix-workstation-gnome:
    pkg:
      name: qubes-template-whonix-ws-gnome
      fromrepo: qubes-templates-community
    #pre: {}
    vm:
      present:
        - template:  whonix-ws-gnome
        - label:     purple
      prefs:
        - action:    set
        - netvm:     $pillar('qubes:defaults:vmnames:whonix-gateway')
        - autostart: false
      require:
        - qvm: $pillar('qubes:defaults:vmnames:whonix-gateway')
    #post: {}
