# The Qubes OS Project, http://www.qubes-os.org
#
# Copyright (C) 2015 Jason Mehring <nrgaway@gmail.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

PACKAGE_NAME     := qubes-mgmt-salt-dom0-virtual-machines
FORMULA_NAME     := $(shell grep 'name' FORMULA|head -n 1|cut -f 2 -d :|xargs)
STATE_NAME       := $(shell grep 'top_level_dir' FORMULA|head -n 1|cut -f 2 -d :|xargs)
SALTENV          := $(shell grep 'saltenv' FORMULA|head -n 1|cut -f 2 -d :|xargs)

ifeq ($(STATE_NAME),)
  STATE_NAME := $(FORMULA_NAME)
endif
ifeq ($(SALTENV),)
  SALTENV := base
endif

FORMULA          ?= README.rst LICENSE virtual-machines
PILLAR           ?= pillar
TEST_FORMULA     ?= 
TEST_PILLAR      ?= 

TESTENV          ?= test
TEST_DIR         ?= tests
SALT_STATE_DIR   ?= srv/salt
SALT_PILLAR_DIR  ?= srv/pillar
SALT_FORMULA_DIR ?= srv/formulas

DESTDIR		 := $(shell readlink -m $(DESTDIR))
FORMULA_DIR       = $(SALT_FORMULA_DIR)/$(SALTENV)/$(FORMULA_NAME)
PILLAR_DIR        = $(SALT_PILLAR_DIR)/$(SALTENV)

VERBOSE ?= 0
VERSION := $(shell cat version)
RELEASE := $(shell cat rel)

all:
	@true

debug = \
	if [ $(VERBOSE) -gt 0 ]; then \
	    echo $(1); \
	fi

install-files = \
	$(eval basepaths = $(1)) \
	$(eval targetdir = $(2)) \
	$(eval relpaths = $(3)) \
	$(call debug, "============================================================"); \
	$(call debug, "DESTDIR:   $(DESTDIR)"); \
	$(call debug, "basepaths: $(basepaths)"); \
	$(call debug, "targetdir: $(targetdir)"); \
	$(call debug, "relpaths:  $(relpaths)"); \
	$(if $(basepaths), \
	    $(shell install -d -m 0750 $(DESTDIR)/$(targetdir)) \
	    $(foreach basepath, $(basepaths), \
	        $(eval files = $(shell find $(basepath))) \
	        $(foreach file, $(files), \
	            $(eval filtered = $(filter $(basepath), $(relpaths))) \
	            $(call debug, "------------------------------------------------------------"); \
	            $(call debug, "  filter-out: |$(filtered)|"); \
	            $(call debug, "    basepath: |$(basepath)|"); \
	            $(if $(filtered), \
	                 $(eval relbase := $(shell realpath --relative-base $(basepath) $(file))), \
	                 $(eval relbase := $(file)) \
		    ) \
	            $(call debug, "        file: |$(file)|"); \
	            $(call debug, "     relbase: |$(relbase)|"); \
	            $(if $(wildcard $(file)/.), \
	                $(call debug, " install DIR: $(targetdir)/$(relbase)"); \
	                $(call debug, ); \
	                $(shell install -d -m 0750 $(DESTDIR)/$(targetdir)/$(relbase)) \
	            , \
	                $(call debug, "install FILE: $(file)"); \
 	                $(call debug, "          TO: $(targetdir)/$(relbase)"); \
	                $(call debug, ); \
	                $(shell install -p -m 0640 $(file) $(DESTDIR)/$(targetdir)/$(relbase)) \
	            ) \
	        ) \
	    ) \
	)

.PHONY: install
install: 
	# Formula
	@$(if $(FORMULA), $(call install-files, $(FORMULA), $(FORMULA_DIR)))
	
	# Pillar
	@$(if $(PILLAR), $(call install-files, $(PILLAR), $(PILLAR_DIR), $(PILLAR)))

	# Formula Tests
	@$(eval SALTENV = $(TESTENV))
	
	# Test Formula Contents (minus state directory)
	@$(if $(filter-out $(TEST_DIR), $(TEST_FORMULA)), \
	      $(call install-files, $(filter-out $(TEST_DIR), $(TEST_FORMULA)), $(FORMULA_DIR)))

	# Test Formula State Directory (rename 'tests' directory to $(STATE_NAME) using relbase
	@$(if $(filter $(TEST_DIR), $(TEST_FORMULA)), \
	      $(call install-files, $(filter $(TEST_DIR), $(TEST_FORMULA)), $(FORMULA_DIR)/$(STATE_NAME), $(TEST_DIR)))
	
	# Test Pillar
	@$(if $(TEST_PILLAR), $(call install-files, $(TEST_PILLAR), $(PILLAR_DIR), $(TEST_PILLAR)))
