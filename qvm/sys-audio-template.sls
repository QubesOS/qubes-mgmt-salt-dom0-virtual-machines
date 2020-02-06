# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-audio-template
# ====================
##


{% if salt['pillar.get']('qvm:sys-audio:name', 'sys-audio') != salt['pillar.get']('qvm:sys-gui:name', 'sys-gui') %}
sys-audio-xfce:
  pkg.installed:
    - pkgs:
      - volumeicon
{% endif %}