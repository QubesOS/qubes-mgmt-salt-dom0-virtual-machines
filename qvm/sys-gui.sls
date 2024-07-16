# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-gui
# ===========
##

{{ salt['pillar.get']('qvm:sys-gui:template', 'fedora-40-xfce') }}:
  qvm.template_installed: []

{% if 'psu' in salt['pillar.get']('qvm:sys-gui:dummy-modules', []) or 'backlight' in salt['pillar.get']('qvm:sys-gui:dummy-modules', []) %}
sys-gui-installed:
  pkg.installed:
    - pkgs:
{% if 'psu' in salt['pillar.get']('qvm:sys-gui:dummy-modules', []) %}
      - dummy-psu-sender
{% endif %}
{% if 'backlight' in salt['pillar.get']('qvm:sys-gui:dummy-modules', []) %}
      - dummy-backlight-dom0
{% endif %}
{% endif %}

{% from "qvm/template.jinja" import load -%}
{% from "qvm/template-gui.jinja" import gui_common -%}

{% load_yaml as defaults -%}
name:          sys-gui
present:
  - label:     black
  - maxmem:    4000
  - template:  {{ salt['pillar.get']('qvm:sys-gui:template', 'fedora-40-xfce') }}
prefs:
  - netvm:     ""
  - guivm:     dom0
  - audiovm:   dom0
  - autostart: true
service:
  - enable:
    - guivm
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
  - set:
    # don't intercept those at dom0, let guivm see them
    - gui-secure-copy-sequence: none
    - gui-secure-paste-sequence: none
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
