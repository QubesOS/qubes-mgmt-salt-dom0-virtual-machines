%{!?version: %define version %(cat version)}

Name:      qubes-mgmt-salt-dom0-virtual-machines
Version:   %{version}
Release:   1%{?dist}
Summary:   Downloads, installs and configures template as well as creating and configuring virtual-machine AppVM's.
License:   GPL 2.0
URL:	   http://www.qubes-os.org/

Group:     System administration tools
BuildArch: noarch
Requires:  qubes-mgmt-salt
Requires:  qubes-mgmt-salt-dom0

%define _builddir %(pwd)

%description
Downloads, installs and configures template as well as creating and configuring virtual-machine AppVM's.
Uses pillar data to define default VM names and configuration details.

%prep
# we operate on the current directory, so no need to unpack anything
# symlink is to generate useful debuginfo packages
rm -f %{name}-%{version}
ln -sf . %{name}-%{version}
%setup -T -D

%build

%install
make install DESTDIR=%{buildroot} LIBDIR=%{_libdir} BINDIR=%{_bindir} SBINDIR=%{_sbindir} SYSCONFDIR=%{_sysconfdir}

%post
# Update Salt Configuration
qubesctl state.sls config -l quiet --out quiet > /dev/null || true
qubesctl saltutil.clear_cache -l quiet --out quiet > /dev/null || true
qubesctl saltutil.sync_all refresh=true -l quiet --out quiet > /dev/null || true

# Enable States
#qubesctl top.enable qvm.sys-net saltenv=dom0 -l quiet --out quiet > /dev/null || true
#qubesctl top.enable qvm.sys-firewall saltenv=dom0 -l quiet --out quiet > /dev/null || true
#qubesctl top.enable qvm.sys-whonix saltenv=dom0 -l quiet --out quiet > /dev/null || true
#qubesctl top.enable qvm.anon-whonix saltenv=dom0 -l quiet --out quiet > /dev/null || true
#qubesctl top.enable qvm.personal saltenv=dom0 -l quiet --out quiet > /dev/null || true
#qubesctl top.enable qvm.work saltenv=dom0 -l quiet --out quiet > /dev/null || true
#qubesctl top.enable qvm.untrusted saltenv=dom0 -l quiet --out quiet > /dev/null || true
#qubesctl top.enable qvm.vault saltenv=dom0 -l quiet --out quiet > /dev/null || true

# Enable Pillar States
qubesctl top.enable qvm saltenv=dom0 pillar=true -l quiet --out quiet > /dev/null || true

%files
%defattr(-,root,root)
%doc LICENSE README.rst
%attr(750, root, root) %dir /srv/formulas/dom0/virtual-machines-formula
/srv/formulas/dom0/virtual-machines-formula/README.rst
/srv/formulas/dom0/virtual-machines-formula/LICENSE
/srv/formulas/dom0/virtual-machines-formula/qvm/anon-whonix.sls
/srv/formulas/dom0/virtual-machines-formula/qvm/anon-whonix.top
/srv/formulas/dom0/virtual-machines-formula/qvm/personal.sls
/srv/formulas/dom0/virtual-machines-formula/qvm/personal.top
/srv/formulas/dom0/virtual-machines-formula/qvm/sys-firewall.sls
/srv/formulas/dom0/virtual-machines-formula/qvm/sys-firewall.top
/srv/formulas/dom0/virtual-machines-formula/qvm/sys-net.sls
/srv/formulas/dom0/virtual-machines-formula/qvm/sys-net.top
/srv/formulas/dom0/virtual-machines-formula/qvm/sys-usb.sls
/srv/formulas/dom0/virtual-machines-formula/qvm/sys-usb.top
/srv/formulas/dom0/virtual-machines-formula/qvm/sys-whonix.sls
/srv/formulas/dom0/virtual-machines-formula/qvm/sys-whonix.top
/srv/formulas/dom0/virtual-machines-formula/qvm/template-debian-7.sls
/srv/formulas/dom0/virtual-machines-formula/qvm/template-debian-8.sls
/srv/formulas/dom0/virtual-machines-formula/qvm/template-fedora-21-minimal.sls
/srv/formulas/dom0/virtual-machines-formula/qvm/template-fedora-21.sls
/srv/formulas/dom0/virtual-machines-formula/qvm/template.jinja
/srv/formulas/dom0/virtual-machines-formula/qvm/template-whonix-gw.sls
/srv/formulas/dom0/virtual-machines-formula/qvm/template-whonix-ws.sls
/srv/formulas/dom0/virtual-machines-formula/qvm/untrusted.sls
/srv/formulas/dom0/virtual-machines-formula/qvm/untrusted.top
/srv/formulas/dom0/virtual-machines-formula/qvm/vault.sls
/srv/formulas/dom0/virtual-machines-formula/qvm/vault.top
/srv/formulas/dom0/virtual-machines-formula/qvm/work.sls
/srv/formulas/dom0/virtual-machines-formula/qvm/work.top

%attr(750, root, root) %dir /srv/pillar/dom0/qvm
%config(noreplace) /srv/pillar/dom0/qvm/init.sls
/srv/pillar/dom0/qvm/init.top

%changelog
