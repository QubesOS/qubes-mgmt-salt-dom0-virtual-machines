# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-gui-gpu
# ===========
##

sys-gui-gpu-template:
  qvm.template_installed:
    - name: {{ salt['pillar.get']('qvm:sys-gui-gpu:template', 'fedora-41-xfce') }}

sys-gui-gpu-installed:
  pkg.installed:
    - pkgs:
      - qubes-input-proxy-sender
{% if 'psu' in salt['pillar.get']('qvm:sys-gui-gpu:dummy-modules', []) %}
      - dummy-psu-sender
{% endif %}

{% from "qvm/template.jinja" import load -%}
{% from "qvm/template-gui.jinja" import gui_common -%}

{% load_yaml as defaults -%}
name:          sys-gui-gpu
present:
  - label:     black
  - maxmem:    4000
  - template:  {{ salt['pillar.get']('qvm:sys-gui-gpu:template', 'fedora-41-xfce') }}
prefs:
  - virt_mode: hvm
  - netvm:     ""
  - guivm:     ""
  - audiovm:   ""
  - memory:    1000
  - autostart: false #TODO true
  - kernelopts: "nopat iommu=soft swiotlb=8192 root=/dev/mapper/dmroot ro console=hvc0 xen_scrub_pages=0"
features:
  - enable:
    - no-default-kernelopts
  - set:
    - video-model: none
    - input-dom0-proxy: true
service:
  - enable:
    - lightdm
    - guivm
{% if 'psu' in salt['pillar.get']('qvm:sys-gui-gpu:dummy-modules', []) %}
    - dummy-psu
{% endif %}
{%- endload %}

# set GuiVM target for input-proxy-sender of dom0 attached input devices (not USB)
/etc/qubes/input-proxy-target:
  file.managed:
    - contents: "TARGET_DOMAIN=sys-gui-gpu"

# Setup Qubes RPC policy for sys-usb to sys-gui-gpu
sys-usb-input-proxy:
  file.managed:
    - name: /etc/qubes/policy.d/45-sys-gui-gpu.policy
{% if salt['pillar.get']('qvm:sys-usb:mouse-action', 'ask') == 'ask' %}
    - text: qubes.InputMouse * {{ salt['pillar.get']('qvm:sys-usb:name', 'sys-usb') }} dom0 ask user=root default_target=sys-gui-gpu
{% elif salt['pillar.get']('qvm:sys-usb:mouse-action', 'ask') == 'allow' %}
    - text: qubes.InputMouse * {{ salt['pillar.get']('qvm:sys-usb:name', 'sys-usb') }} dom0 allow user=root target=sys-gui-gpu
{% endif %}

{{ load(defaults) }}
{{ gui_common(defaults.name) }}
