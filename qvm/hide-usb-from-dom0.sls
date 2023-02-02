# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.hide-usb-from-dom0
# ===========
#
# Prevent accessing USB controllers in dom0.
#
# Execute:
#   qubesctl state.sls qvm.hide-usb-from-dom0
##

{% set uefi_xen_cfg = '/boot/efi/EFI/qubes/xen.cfg' %}
{% set grub_cfg = '/boot/grub2/grub.cfg' %}

# file.line module is supported only in salt 2015.08 or later...
hide-usb-from-dom0-uefi:
  cmd.run:
{% if salt['pillar.get']('qvm:sys-usb:keyboard-action', 'deny') == 'allow' %}
    - name: sed -i -e 's/^kernel=.*/\0 usbcore.authorized_default=0/' {{ uefi_xen_cfg }}
    - unless: grep usbcore.authorized_default {{ uefi_xen_cfg }}
{% else %}
    - name: sed -i -e 's/^kernel=.*/\0 rd.qubes.hide_all_usb/' {{ uefi_xen_cfg }}
    - unless: grep rd.qubes.hide_all_usb {{ uefi_xen_cfg }}
{% endif %}
    - onlyif: test -f {{uefi_xen_cfg}}


hide-usb-from-dom0-grub:
  file.append:
    - name: /etc/default/grub
{% if salt['pillar.get']('qvm:sys-usb:keyboard-action', 'deny') == 'allow' %}
    - text: GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX usbcore.authorized_default=0"
{% else %}
    - text: GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX rd.qubes.hide_all_usb"
{% endif %}
    - onlyif: test -f /etc/default/grub


grub2-mkconfig -o {{grub_cfg}}:
  cmd.run:
    - onchanges:
      - file: hide-usb-from-dom0-grub
    - onlyif: test -f {{grub_cfg}}
