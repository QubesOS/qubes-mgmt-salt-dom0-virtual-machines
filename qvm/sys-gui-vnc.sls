# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-gui-vnc
# ===============
##

{{ salt['pillar.get']('qvm:sys-gui-vnc:template', 'fedora-34-xfce') }}:
  qvm.template_installed: []

{% if 'psu' in salt['pillar.get']('qvm:sys-gui-vnc:dummy-modules', []) %}
dummy-psu-sender:
  pkg.installed: []
{% endif %}
{% if 'backlight' in salt['pillar.get']('qvm:sys-gui-vnc:dummy-modules', []) %}
dummy-backlight-dom0:
  pkg.installed: []
{% endif %}

{% from "qvm/template.jinja" import load -%}
{% from "qvm/template-gui.jinja" import gui_common -%}

{% load_yaml as defaults -%}
name:          sys-gui-vnc
present:
  - label:     black
  - maxmem:    4000
  - template:  {{ salt['pillar.get']('qvm:sys-gui-vnc:template', 'fedora-34-xfce') }}
prefs:
  - netvm:     ""
  - guivm:     dom0
  - audiovm:   ""
  - autostart: true
service:
  - enable:
    - lightdm
    - guivm
    - guivm-gui-vnc
{% if 'psu' in salt['pillar.get']('qvm:sys-gui-vnc:dummy-modules', []) %}
    - dummy-psu
{% endif %}
{% if 'backlight' in salt['pillar.get']('qvm:sys-gui-vnc:dummy-modules', []) %}
    - dummy-backlight
{% endif %}
{%- endload %}

{{ load(defaults) }}
{{ gui_common(defaults.name) }}
