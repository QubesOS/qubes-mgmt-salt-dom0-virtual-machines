# -*- coding: utf-8 -*-
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# qvm.disposable-preload
# ========
#
# Sets global preload features on dom0 if respective pillar is enabled and they
# are not set already, affects default_dispvm (default-dvm).
#
# Execute:
#   qubesctl top.enable qvm.disposable-preload pillar=True
#   qubesctl state.apply qvm.disposable-preload
##

{#-
Str to int: |int
int (can be float) to python's int: |round|int

Threshold is always set independent of pillar because this state is run on dom0
while other programs that use the threshold, may be on GUI domain and not have
access to the "xl" command.
#}

{%- set preload_pillar = salt['pillar.get']('qvm:dom0:preload', False) %}
{%- set total_memory_MiB = salt['cmd.shell']('xl info total_memory') | int | round | int %}
{%- set total_memory_GB = (total_memory_MiB * 2**20 / 10**9) | round | int %}
{%- if total_memory_GB >= 32 %}
  {%- set preload_max = 2 %}
{%- else %}
  {%- set preload_max = 1 %}
{%- endif %}
{%- set preload_threshold = salt['pillar.get']('qvm:dom0:preload-threshold', none) %}
{%- if preload_threshold is none %}
  {%- if total_memory_GB <= 8 %}
    {# Installer doesn't allow such low amount of memory to preload, but if
      user explicitly enables the preload pillar, set a lower threshold. #}
    {%- set preload_threshold = 500 %}
  {%- else %}
    {%- set preload_threshold = (total_memory_MiB * 0.05) | round | int %}
    {%- set preload_threshold = [preload_threshold, 1000] | max %}
    {%- set preload_threshold = [preload_threshold, 6000] | min %}
  {%- endif %}
{%- endif %}
disposable-preload:
  qvm.vm:
    - name: dom0
    - features:
      - set:
        - preload-dispvm-threshold: {{ preload_threshold }}
        {%- if preload_pillar %}
        - preload-dispvm-max: {{ preload_max }}
        {%- endif %}
