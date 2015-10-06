%{!?version: %define version %(cat version)}
%{!?rel: %define rel %(cat rel)}

%{!?formula_name: %define formula_name %(grep 'name' FORMULA|head -n 1|cut -f 2 -d :|xargs)}
%{!?state_name: %define state_name %(grep 'top_level_dir' FORMULA|head -n 1|cut -f 2 -d :|xargs)}
%{!?saltenv: %define saltenv %(grep 'saltenv' FORMULA|head -n 1|cut -f 2 -d :|xargs)}

%if "%{state_name}" == ""
  %define state_name %{formula_name}
%endif

%if "%{saltenv}" == ""
  %define saltenv base
%endif

%define salt_state_dir /srv/salt
%define salt_pillar_dir /srv/pillar
%define salt_formula_dir /srv/formulas

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
make install DESTDIR=%{buildroot} LIBDIR=%{_libdir} BINDIR=%{_bindir} SBINDIR=%{_sbindir} SYSCONFDIR=%{_sysconfdir} VERBOSE=%{_verbose}

%post
# Update Salt Configuration
qubesctl state.sls qubes.config -l quiet --out quiet > /dev/null || true
qubesctl saltutil.sync_all -l quiet --out quiet > /dev/null || true

# Enable States
#qubesctl topd.enable %{state_name} saltenv=%{saltenv} -l quiet --out quiet > /dev/null || true

# Enable Pillar States
qubesctl topd.enable %{state_name} saltenv=%{saltenv} pillar=true -l quiet --out quiet > /dev/null || true

%files
%defattr(-,root,root)
%attr(750, root, root) %dir %{salt_formula_dir}/%{saltenv}/%{formula_name}
%{salt_formula_dir}/%{saltenv}/%{formula_name}/*

%attr(750, root, root) %dir %{salt_pillar_dir}/%{saltenv}/%{state_name}
%config(noreplace) %{salt_pillar_dir}/%{saltenv}/%{state_name}/init.sls
%config(noreplace) %{salt_pillar_dir}/%{saltenv}/%{state_name}/init.top

%changelog
