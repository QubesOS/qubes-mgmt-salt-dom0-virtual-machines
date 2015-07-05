ifndef LOADING_PLUGINS
    ifeq ($(PACKAGE_SET),dom0)
        RPM_SPEC_FILES := rpm_spec/qubes-mgmt-salt-dom0-virtual-machines.spec
        RPM_BUILD_DEFINES += --define "_verbose $(VERBOSE)"

    else ifeq ($(PACKAGE_SET),vm)
        ifneq ($(filter $(DISTRIBUTION), debian qubuntu),)
            DEBIAN_BUILD_DIRS := debian
            SOURCE_COPY_IN := source-debian-mgmt-salt-dom0-virtual-machines-copy-in
        endif

        RPM_SPEC_FILES := rpm_spec/qubes-mgmt-salt-dom0-virtual-machines.spec
        RPM_BUILD_DEFINES += --define "_verbose $(VERBOSE)"
    endif

    source-debian-mgmt-salt-dom0-virtual-machines-copy-in: VERSION = $(shell $(DEBIAN_PARSER) changelog --package-version $(ORIG_SRC)/$(DEBIAN_BUILD_DIRS)/changelog)
    source-debian-mgmt-salt-dom0-virtual-machines-copy-in: NAME = $(shell $(DEBIAN_PARSER) changelog --package-name $(ORIG_SRC)/$(DEBIAN_BUILD_DIRS)/changelog)
    source-debian-mgmt-salt-dom0-virtual-machines-copy-in: ORIG_FILE = "$(CHROOT_DIR)/$(DIST_SRC)/../$(NAME)_$(VERSION).orig.tar.gz"
    source-debian-mgmt-salt-dom0-virtual-machines-copy-in:
	 -$(shell $(ORIG_SRC)/debian-quilt $(ORIG_SRC)/series-debian-vm.conf $(CHROOT_DIR)/$(DIST_SRC)/debian/patches)
	 tar cfz $(ORIG_FILE) --exclude-vcs --exclude=./rpm --exclude=./pkgs --exclude=./deb --exclude=./debian -C $(CHROOT_DIR)/$(DIST_SRC) .
endif
# vim: filetype=make
