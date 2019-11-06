# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-gui
# ===========
##

qubes-template-{{ salt['pillar.get']('qvm:sys-gui:template', 'fedora-30-xfce') }}:
  pkg.installed: []

{% from "qvm/template.jinja" import load -%}

{% load_yaml as defaults -%}
name:          sys-gui
present:
  - label:     black
  - maxmem:    4000
  - template:  {{ salt['pillar.get']('qvm:sys-gui:template', 'fedora-30-xfce') }}
prefs:
  - netvm:     ""
  - guivm:     dom0
  - autostart: true
service:
  - enable:
    - guivm-gui-agent
{%- endload %}

{{ load(defaults) }}

# Set 'dom0' keyboard-layout feature
dom0-keyboard-layout:
  cmd.run:
    - name: qvm-features dom0 keyboard-layout {{ salt['keyboard.get_x']() }}

# Set 'sys-gui' as default GuiVM
sys-gui-default-guivm:
  cmd.run:
    - name: qubes-prefs default_guivm sys-gui
    - require:
      - qvm: sys-gui

# Setup Qubes RPC policy
sys-gui-rpc:
  file.managed:
    - name: /etc/qubes/policy.d/30-sys-gui.policy
    - contents: |
        qubes.SetMonitorLayout              *   sys-gui             @tag:guivm-sys-gui  allow
        qubes.GetImageRGBA                  *   sys-gui             @tag:guivm-sys-gui  allow
        qubes.SyncAppMenus                  *   @tag:guivm-sys-gui  dom0                allow   target=sys-gui
        qubes.StartApp                      *   sys-gui             @tag:guivm-sys-gui  allow
        qubes.WaitForSession                *   sys-gui             @tag:guivm-sys-gui  allow
        qubes.GetAppmenus                   *   sys-gui             @tag:guivm-sys-gui  allow

        admin.Events                        *   sys-gui             @adminvm            allow
        admin.label.Index                   *   sys-gui             @adminvm            allow
        admin.label.Get                     *   sys-gui             @adminvm            allow
        admin.vm.List                       *   sys-gui             @adminvm            allow   target=@adminvm
        admin.vm.List                       *   sys-gui             @tag:guivm-sys-gui  allow   target=dom0
        admin.vm.property.Get               *   sys-gui             @tag:guivm-sys-gui  allow   target=dom0
        admin.vm.feature.Get                *   sys-gui             @tag:guivm-sys-gui  allow   target=dom0
        admin.vm.feature.CheckWithTemplate  *   sys-gui             @tag:guivm-sys-gui  allow   target=dom0
