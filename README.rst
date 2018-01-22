========================
Virtual Machines Formula
========================

Downloads, installs and configures template as well as creating and
configuring virtual-machine AppVM's.

Uses pillar data to define default VM names and configuration details.  Default
settings can be overridden in pillar data located at:
    ``/srv/pillar/base/qvm/init.sls``

Available states
================

.. contents::
    :local:

``qvm.sys-net``
---------------
System NetVM

``qvm.sys-usb``
---------------
System UsbVM

``qvm.sys-net-with-usb``
---------------
System UsbVM bundled into NetVM. Do not enable together with ``qvm.sys-usb``.

``qvm.sys-firewall``
--------------------
System firewall ProxyVM

``qvm.sys-whonix``
------------------
Whonix gateway ProxyVM

``qvm.personal``
----------------
Personal AppVM

``qvm.work``
------------
Work AppVM

``qvm.untrusted``
-----------------
Untrusted AppVM

``qvm.vault``
-------------
Vault AppVM with no NetVM enabled.

``qvm.default-dispvm``
-------------
Default Disposable VM template - fedora-26-dvm AppVM

``qvm.anon-whonix``
-------------------
Whonix workstation AppVM.

``qvm.whonix-ws-dvm``
-------------------
Whonix workstation AppVM for Whonix Disposable VMs.

``qvm.updates-via-whonix``
-------------------
Setup UpdatesProxy to route all templates updates through Tor (sys-whonix here).

``qvm.template-fedora-21``
--------------------------
Fedora-21 TemplateVM

``qvm.template-fedora-21-minimal``
----------------------------------
Fedora-21 minimal TemplateVM

``qvm.template-debian-7``
-------------------------
Debian 7 (wheezy) TemplateVM

``qvm.template-debian-8``
-------------------------
Debian 8 (jessie) TemplateVM

``qvm.template-whonix-gw``
--------------------------
Whonix Gateway TemplateVM

``qvm.template-whonix-ws``
--------------------------
Whonix Workstation TemplateVM
