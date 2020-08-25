# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-gui
# ===========
##

qubes-template-{{ salt['pillar.get']('qvm:sys-gui:template', 'fedora-32-xfce') }}:
  pkg.installed: []

{% if 'psu' in salt['pillar.get']('qvm:sys-gui:dummy-modules', []) %}
dummy-psu-dom0:
  pkg.installed: []
{% endif %}
{% if 'backlight' in salt['pillar.get']('qvm:sys-gui:dummy-modules', []) %}
dummy-backlight-dom0:
  pkg.installed: []
{% endif %}

{% from "qvm/template.jinja" import load -%}
{% from "qvm/template-gui.jinja" import gui_common -%}

{% load_yaml as defaults -%}
name:          sys-gui
present:
  - label:     black
  - maxmem:    4000
  - template:  {{ salt['pillar.get']('qvm:sys-gui:template', 'fedora-32-xfce') }}
prefs:
  - netvm:     ""
  - guivm:     dom0
  - audiovm:   ""
  - autostart: true
service:
  - enable:
    - guivm-gui-agent
{% if 'psu' in salt['pillar.get']('qvm:sys-gui:dummy-modules', []) %}
    - dummy-psu
{% endif %}
{% if 'backlight' in salt['pillar.get']('qvm:sys-gui:dummy-modules', []) %}
    - dummy-backlight
{% endif %}
features:
  - enable:
    - gui-allow-fullscreen
{%- endload %}

/usr/share/xsessions/sys-gui.desktop:
  file.managed:
    - contents: |
        [Desktop Entry]
        Name=GUI Domain (sys-gui)
        Exec=qubes-guivm-session sys-gui
        Type=Application

{{ load(defaults) }}
{{ gui_common(defaults.name) }}
