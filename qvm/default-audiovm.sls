{% if salt['pillar.get']('qvm:sys-audio:name', 'sys-audio') != salt['pillar.get']('qvm:sys-gui:name', 'sys-gui') %}
{% set vmname = salt['pillar.get']('qvm:sys-audio:name', 'sys-audio') %}
{% else %}
{% set vmname = salt['pillar.get']('qvm:sys-gui:name', 'sys-gui') %}
{% endif %}

# Set 'sys-audio' (or 'sys-gui') as default AudioVM
{{ vmname }}-default-audiovm:
  cmd.run:
    - name: qubes-prefs default_audiovm {{ vmname }}
