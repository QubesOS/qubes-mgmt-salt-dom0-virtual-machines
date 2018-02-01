# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.usb-keyboard
# ===========
#
# Allows USB keyboard access through UsbVM (sys-usb)
#
# Pillar data will also be used to locate usbvm, using pillar key:
#   ``qvm:sys-usb:name``
#
# located in ``/srv/pillar/dom0/qvm/init.sls``
#
# Execute:
#   qubesctl state.sls qvm.usb-keyboard
##

include:
 - qvm.sys-usb

{% from "qvm/template.jinja" import load -%}

# Setup Qubes RPC policy
sys-usb-input-proxy-keyboard:
  file.prepend:
    - name: /etc/qubes-rpc/policy/qubes.InputKeyboard
    - text: {{ salt['pillar.get']('qvm:sys-usb:name', 'sys-usb') }} dom0 allow,user=root
    - require:
      - pkg:       qubes-input-proxy


{% if grains['boot_mode'] == 'efi' %}

{% set uefi_xen_cfg = '/boot/efi/EFI/qubes/xen.cfg' %}

unhide-usb-from-dom0-uefi:
  file.replace:
    - name: {{ uefi_xen_cfg }}
    - pattern: ' rd.qubes.hide_all_usb'
    - repl: ''

{% else %}

unhide-usb-from-dom0-legacy:
  file.replace:
    - name: /etc/default/grub
    - pattern: ' rd.qubes.hide_all_usb'
    - repl: ''

grub-regenerate-unhide:
  cmd.run:
    - name: grub2-mkconfig -o /boot/grub2/grub.cfg
    - onchanges:
      - file: unhide-usb-from-dom0-legacy

{% endif %}
