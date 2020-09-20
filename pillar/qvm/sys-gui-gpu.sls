# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

# 'user' refers to dom0 user from where to get password
{% set user = 'admin' %}
# 'password_hash' is obtained from /etc/shadow with corresponding
# user set above.
{% set password_hash = salt['shadow.info'](user).get('passwd') %}

# Default password is set to '123456'
{% if password_hash == '' %}
{% set password_hash = '$1$eByLDWM4$RgCTKI9aKAsNSbKopFSZ11' %}
{% endif %}

qvm:
    sys-gui-gpu:
        admin-global-permissions: 'rwx'
        dummy-modules:
            - psu
    sys-gui-gpu-vm:
        password-hash: {{ password_hash }}