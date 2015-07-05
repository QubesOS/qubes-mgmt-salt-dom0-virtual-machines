#!yamlscript
#
# vim: set syntax=yaml ts=2 sw=2 sts=2 et :

##
# Qubes Virtual Machine Installation
#
# qubesctl state.sls virtual-machines
#
# This state will install virtual machines from the
# 'qubes:defaults:virtual-machines' pillar that describes the desired default
# virtual machines to be installed (/srv/salt/pillars/dom0/init-machines.sls)
# using pillar data that provides default settings for each type of
# virtual machine (/srv/salt/pillars/dom0/virtual-machines.sls)
#
# The state will fail if the template package is not installed and fails to
# install.
#
# The state will be skipped if a VM of the same name already exists.
##


# Turn in debugging mode (shows all result comment message instead of just the
# last message
$if pillar('qubes:debug'):
  virtual-machines-debug-id:
    debug.mode:
      - enable-all: true

$for vmname, vmtype in pillar('qubes:defaults:virtual-machines', {}).items():
  $python: |
      # TODO: First attempt to retreive pillar from user_pillars and fallback
      #       to qubes pillar directory
      virtual_machine = pillar('virtual-machines:{0}'.format(vmtype), None)

  $if virtual_machine:
    # Ensure template package is installed based on pillar values
    $with template_id:
      pkg.installed:
        - __id__:   $'{0}_{1}'.format(vmname, template_id.pkg.name)
        - __data__: $virtual_machine['pkg']

      # Don't attempt to install the VM if its already installed
      $if __salt__['qvm.check'](vmname, 'missing').passed():
        virtual_machine_id:
          qvm.vm:
            - __id__:   $vmname
            - __data__: $virtual_machine['vm']

      # Just show a message that the VM is already installed
      $else:
        virtual_machine_id:
          qvm.exists:
            - __id__: $vmname

  $else:
    virtual_machine_id:
      status.create:
        - __id__:  $vmname
        - result: false
        - comment: |
            $'VM type \'{0}\' not found in virtual-machines pillar!'.format(vmtype)
