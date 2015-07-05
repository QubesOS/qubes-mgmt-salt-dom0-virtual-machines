%{!?version: %define version %(cat version)}
%{!?rel: %define rel %(cat rel)}
%{!?formula_name: %define formula_name %(cat formula_name)}

Name:      qubes-mgmt-salt-dom0-virtual-machines
Version:   %{version}
Release:   %{rel}%{?dist}
Summary:   Downloads, installs and configures template as well as creating and configuring virtual-machine AppVM's.
License:   GPL 2.0
URL:	   http://www.qubes-os.org/

Group:     System administration tools
BuildArch: noarch
Requires:  qubes-mgmt-salt-base
Requires:  qubes-mgmt-salt-config
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
# TODO:
# - Add formula path to file_roots
# - Add formula to salt top.sls
# - Add formula to pillar top.sls if contains pillar data
mkdir -p /srv/pillar/dom0/qubes
ln -sf /srv/formulas/dom0/virtual-machines-formula/pillar/qubes/init.sls /srv/pillar/dom0/qubes/init.sls
ln -sf /srv/formulas/dom0/virtual-machines-formula/pillar/qubes/virtual-machines.sls /srv/pillar/dom0/qubes/virtual-machines.sls
salt-call --local saltutil.sync_all -l quiet --out quiet > /dev/null || true

%files
%defattr(-,root,root)
%attr(750, root, root) %dir /srv/formulas/dom0/%{formula_name}
/srv/formulas/dom0/%{formula_name}/*

%changelog
