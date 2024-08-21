# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

# 'user' refers to the first dom0 user in 'qubes' group
{% set user = salt['group.info']('qubes').get('members')[0] %}
# 'password_hash' is obtained from /etc/shadow with corresponding
# user set above.
{% set password_hash = salt['cmd.run']("getent shadow " + user).split(":")[1] %}

# Default password is set to '123456'
{% if password_hash == '' %}
{% set password_hash = '$1$eByLDWM4$RgCTKI9aKAsNSbKopFSZ11' %}
{% endif %}

qvm:
    sys-gui-vnc:
        admin-global-permissions: 'rwx'
        dummy-modules:
            - psu
    sys-gui-vnc-vm:
        password-hash: {{ password_hash }}
