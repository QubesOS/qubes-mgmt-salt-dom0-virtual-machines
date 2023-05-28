# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.sys-usb
# ===========
#
# Installs 'sys-usb' UsbVM.
#
# Pillar data will also be merged if available within the ``qvm`` pillar key:
#   ``qvm:sys-usb``
#
# located in ``/srv/pillar/dom0/qvm/init.sls``
#
# Execute:
#   qubesctl state.sls qvm.sys-usb dom0
##

{% set default_template = salt['cmd.shell']('qubes-prefs default-template') %}

{% set usb_pcidevs = salt['grains.get']('pci_usb_devs', []) %}
# leave devices listed in rd.qubes.dom0_usb alone
{% for param, value in salt['grains.get']('kernelparams', []) %}
  {% if param == 'rd.qubes.dom0_usb' and value is string %}
    {% for dev in value.split(',') %}
      {% if dev in usb_pcidevs %}
        {% do usb_pcidevs.remove(dev) %}
      {% endif %}
    {% endfor %}
  {% endif %}
{% endfor %}

include:
  {% if salt['pillar.get']('qvm:sys-usb:disposable', false) %}
  - qvm.default-dispvm
  {% endif %}
  - qvm.hide-usb-from-dom0

{% from "qvm/template.jinja" import load -%}

# Avoid duplicated states
{% if salt['pillar.get']('qvm:sys-usb:name', 'sys-usb') != salt['pillar.get']('qvm:sys-net:name', 'sys-net') %}

{% load_yaml as defaults -%}
name:          sys-usb
present:
  {% if salt['pillar.get']('qvm:sys-usb:disposable', false) %}
  - class:     DispVM
  - template:  default-dvm
  {% endif %}
  - label:     red
  - mem:       400
  - flags:
    - net
prefs:
  - netvm:     ""
  - virt_mode: hvm
  - autostart: true
  - pcidevs:   {{ usb_pcidevs|yaml }}
  - pci_strictreset: false
service:
  - disable:
    - network-manager
    - meminfo-writer
{% if salt['pillar.get']('qvm:sys-usb:disposable', false) %}
require:
  - qvm:       default-dvm
{% endif %}
{%- endload %}

{{ load(defaults) }}

{% else %}

{% set vmname = salt['pillar.get']('qvm:sys-net:name', 'sys-net') %}

{{ vmname }}-usb:
  qvm.prefs:
    - name: {{ vmname }}
    - pcidevs: {{ (salt['grains.get']('pci_net_devs', []) + usb_pcidevs)|yaml }}
    - pci_strictreset: False
    - require:
      - sls: qvm.sys-net

{% endif %}

qubes-input-proxy:
  pkg.installed: []

{% if salt['pillar.get']('qvm:sys-usb:mouse-action', 'ask') == 'ask' %}
{% set mouse_action = 'ask default_target=dom0' %}
{% elif salt['pillar.get']('qvm:sys-usb:mouse-action', 'ask') == 'allow' %}
{% set mouse_action = 'allow' %}
{% else %}
{% set mouse_action = 'deny' %}
{% endif %}

{% if salt['pillar.get']('qvm:sys-usb:keyboard-action', 'deny') == 'ask' %}
{% set keyboard_action = 'ask default_target=dom0' %}
{% elif salt['pillar.get']('qvm:sys-usb:keyboard-action', 'deny') == 'allow' %}
{% set keyboard_action = 'allow' %}
{% else %}
{% set keyboard_action = 'deny' %}
{% endif %}

# Setup Qubes RPC policy
sys-usb-input-proxy:
  file.managed:
    - name: /etc/qubes/policy.d/50-config-input.policy
    - contents: |
        qubes.InputMouse * {{ salt['pillar.get']('qvm:sys-usb:name', 'sys-usb') }} dom0 {{ mouse_action }}
        qubes.InputKeyboard * {{ salt['pillar.get']('qvm:sys-usb:name', 'sys-usb') }} dom0 {{ keyboard_action }}
        # not configurable by this state
        qubes.InputTablet * {{ salt['pillar.get']('qvm:sys-usb:name', 'sys-usb') }} dom0 deny
    - require:
      - pkg:       qubes-input-proxy

/etc/systemd/system/qubes-vm@{{ salt['pillar.get']('qvm:sys-usb:name', 'sys-usb') }}.service.d/50_autostart.conf:
  file.managed:
    - contents: |
        [Unit]
        Before=systemd-user-sessions.service
    - makedirs: True
