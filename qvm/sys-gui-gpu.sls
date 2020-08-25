# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-gui-gpu
# ===========
##

sys-gui-gpu-template:
  pkg.installed:
    - name: qubes-template-{{ salt['pillar.get']('qvm:sys-gui-gpu:template', 'fedora-32-xfce') }}

{% if 'psu' in salt['pillar.get']('qvm:sys-gui-gpu:dummy-modules', []) %}
dummy-psu-dom0:
  pkg.installed: []
{% endif %}

{% from "qvm/template.jinja" import load -%}
{% from "qvm/template-gui.jinja" import gui_common -%}

{% load_yaml as defaults -%}
name:          sys-gui-gpu
present:
  - label:     black
  - maxmem:    4000
  - template:  {{ salt['pillar.get']('qvm:sys-gui-gpu:template', 'fedora-32-xfce') }}
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
service:
  - enable:
    - lightdm
    - guivm-gui-agent
{% if 'psu' in salt['pillar.get']('qvm:sys-gui-gpu:dummy-modules', []) %}
    - dummy-psu
{% endif %}
{%- endload %}

{{ load(defaults) }}
{{ gui_common(defaults.name) }}
