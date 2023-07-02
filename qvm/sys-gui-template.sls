# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-gui-template
# ====================
##

# WIP: until we have our group packages included
# in Qubes VM repositories, we explicitely list needed packages
sys-gui-xfce:
  pkg.installed:
    - pkgs:
# Qubes related packages
      - qubes-manager
      - qubes-desktop-linux-manager
      - qubes-vm-guivm
# XFCE related packages
      - arc-theme
      - gvfs
      - xdg-user-dirs-gtk
      - xfce4-appfinder
      - xfce4-datetime-plugin
      - xfce4-panel
      - xfce4-places-plugin
      - xfce4-power-manager
      - xfce4-pulseaudio-plugin
      - xfce4-session
      - xfce4-settings
      - xfce4-settings-qubes
      - xfce4-taskmanager
      - xfce4-terminal
      - xfconf
      - xfwm4
{% if grains['os'] == 'Fedora' %}
      - dummy-psu-receiver
      - dummy-psu-module
      - dummy-backlight-vm
      - adwaita-gtk2-theme
      - adwaita-icon-theme
      - greybird-dark-theme
      - greybird-light-theme
      - greybird-xfce4-notifyd-theme
      - greybird-xfwm4-theme
      - gtk-xfce-engine
      - lightdm-gtk
      - xfce4-about
      - xfce4-screenshooter-plugin
      - xfdesktop
      - xfwm4-themes
      - xscreensaver-base
{% elif grains['os'] == 'Debian' %}
      - blackbird-gtk-theme
      - gnome-themes-standard
      - greybird-gtk-theme
      - gtk3-engines-xfce
      - libxfce4ui-utils
      - lightdm
      - xfce4-screenshooter
      - xfdesktop4
      - xscreensaver
{% endif %}

/etc/systemd/system/lightdm.service.d/qubes.conf:
  file.managed:
    - makedirs: True
    - contents: |
        [Unit]
        ConditionPathExists=/var/run/qubes-service/lightdm
        [Install]
        WantedBy=multi-user.target

sys-gui-template-lightdm:
  cmd.run:
    - name: systemctl enable lightdm

sys-gui-template-lock-root:
  user.present:
    - name: root
    - password: '!!'
