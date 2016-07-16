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


{% if grains['boot_mode'] == 'efi' %}

{% set uefi_xen_cfg = '/boot/efi/EFI/qubes/xen.cfg' %}

# file.line module is supported only in salt 2015.08 or later...
hide-usb-from-dom0-uefi:
  cmd.run:
    - name: sed -i -e 's/^kernel=.*/\0 rd.qubes.hide_all_usb/' {{ uefi_xen_cfg }}
    - unless: grep rd.qubes.hide_all_usb {{ uefi_xen_cfg }}

{% else %}

hide-usb-from-dom0-legacy:
  file.append:
    - name: /etc/default/grub
    - text: GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX rd.qubes.hide_all_usb"


grub2-mkconfig -o /boot/grub2/grub.cfg:
  cmd.run:
    - onchanges:
      - file: hide-usb-from-dom0-legacy

{% endif %}
