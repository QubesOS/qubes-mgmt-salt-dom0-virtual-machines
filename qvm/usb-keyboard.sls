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


{% set uefi_xen_cfg = '/boot/efi/EFI/qubes/xen.cfg' %}
{% if grains['boot_mode'] == 'efi' %}
{% set grub_cfg = '/boot/efi/EFI/qubes/grub.cfg' %}
{% else %}
{% set grub_cfg = '/boot/grub2/grub.cfg' %}
{% endif %}

unhide-usb-from-dom0-uefi:
  file.replace:
    - name: {{ uefi_xen_cfg }}
    - pattern: ' rd.qubes.hide_all_usb'
    - repl: ''
    - onlyif: test -f {{ uefi_xen_cfg }}

unhide-usb-from-dom0-grub:
  file.replace:
    - name: /etc/default/grub
    - pattern: ' rd.qubes.hide_all_usb'
    - repl: ''
    - onlyif: test -f /etc/default/grub

grub-regenerate-unhide:
  cmd.run:
    - name: grub2-mkconfig -o {{grub_cfg}}
    - onchanges:
      - file: unhide-usb-from-dom0-grub
    - onlyif: test -f {{grub_cfg}}
