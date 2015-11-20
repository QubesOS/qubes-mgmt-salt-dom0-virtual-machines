%{!?version: %define version %(make get-version)}
%{!?rel: %define rel %(make get-release)}
%{!?package_name: %define package_name %(make get-package_name)}
%{!?package_summary: %define package_summary %(make get-summary)}
%{!?package_description: %define package_description %(make get-description)}

%{!?formula_name: %define formula_name %(make get-formula_name)}
%{!?state_name: %define state_name %(make get-state_name)}
%{!?saltenv: %define saltenv %(make get-saltenv)}
%{!?pillar_dir: %define pillar_dir %(make get-pillar_dir)}
%{!?formula_dir: %define formula_dir %(make get-formula_dir)}

Name:      %{package_name}
Version:   %{version}
Release:   %{rel}%{?dist}
Summary:   %{package_summary}
License:   GPL 2.0
URL:	   http://www.qubes-os.org/

Group:     System administration tools
BuildArch: noarch
Requires:  qubes-mgmt-salt
Requires:  qubes-mgmt-salt-dom0

%define _builddir %(pwd)

%description
%{package_description}

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
#qubesctl top.enable %{state_name}.sys-net saltenv=%{saltenv} -l quiet --out quiet > /dev/null || true
#qubesctl top.enable %{state_name}.sys-firewall saltenv=%{saltenv} -l quiet --out quiet > /dev/null || true
#qubesctl top.enable %{state_name}.sys-whonix saltenv=%{saltenv} -l quiet --out quiet > /dev/null || true
#qubesctl top.enable %{state_name}.anon-whonix saltenv=%{saltenv} -l quiet --out quiet > /dev/null || true
#qubesctl top.enable %{state_name}.personal saltenv=%{saltenv} -l quiet --out quiet > /dev/null || true
#qubesctl top.enable %{state_name}.work saltenv=%{saltenv} -l quiet --out quiet > /dev/null || true
#qubesctl top.enable %{state_name}.untrusted saltenv=%{saltenv} -l quiet --out quiet > /dev/null || true
#qubesctl top.enable %{state_name}.vault saltenv=%{saltenv} -l quiet --out quiet > /dev/null || true

# Enable Pillar States
qubesctl top.enable %{state_name} saltenv=%{saltenv} pillar=true -l quiet --out quiet > /dev/null || true

%files
%defattr(-,root,root)
%attr(750, root, root) %dir /srv/formulas/dom0/virtual-machines-formula
/srv/formulas/dom0/virtual-machines-formula/LICENSE
/srv/formulas/dom0/virtual-machines-formula/qvm/anon-whonix.sls
/srv/formulas/dom0/virtual-machines-formula/qvm/anon-whonix.top
/srv/formulas/dom0/virtual-machines-formula/qvm/personal.sls
/srv/formulas/dom0/virtual-machines-formula/qvm/personal.top
/srv/formulas/dom0/virtual-machines-formula/qvm/sys-firewall.sls
/srv/formulas/dom0/virtual-machines-formula/qvm/sys-firewall.top
/srv/formulas/dom0/virtual-machines-formula/qvm/sys-net.sls
/srv/formulas/dom0/virtual-machines-formula/qvm/sys-net.top
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
/srv/formulas/dom0/virtual-machines-formula/README.rst

%attr(750, root, root) %dir /srv/pillar/dom0/qvm
%config(noreplace) /srv/pillar/dom0/qvm/init.sls
/srv/pillar/dom0/qvm/init.top

%changelog
