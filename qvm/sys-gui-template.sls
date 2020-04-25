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
      - qubes-vm-guivm
      - qubes-manager
      - xfce4-settings-qubes
      - adwaita-gtk2-theme
      - adwaita-icon-theme
      - albatross-gtk2-theme
      - albatross-gtk3-theme
      - albatross-xfwm4-theme
      - alsa-utils
      - arc-theme
      - blueberry
      - bluebird-gtk2-theme
      - bluebird-gtk3-theme
      - bluebird-xfwm4-theme
      - dnfdragora-updater
      - greybird-light-theme
      - greybird-dark-theme
      - greybird-xfce4-notifyd-theme
      - greybird-xfwm4-theme
      - gtk-xfce-engine
      - gvfs
      - initial-setup-gui
      - openssh-askpass
      - vim-enhanced
      - xdg-user-dirs-gtk
      - xfce4-appfinder
      - xfce4-datetime-plugin
      - xfce4-places-plugin
      - xfce4-pulseaudio-plugin
      - xfce4-screenshooter-plugin
      - xfce4-taskmanager
      - xfce4-terminal
      - xfwm4-theme-nodoka
      - xfwm4-themes
      - xscreensaver-base
      - lightdm-gtk
      - xfce4-about
      - xfce4-panel
      - xfce4-power-manager
      - xfce4-session
      - xfce4-settings
      - xfconf
      - xfdesktop
      - xfwm4

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
