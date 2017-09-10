# Class: env_base
# ===========================
#
# Full description of class env_base here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'env_base':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2017 Your name here, unless otherwise noted.
#
class env_base {
  include ntp
  include env_hosts
  include env_users
  include env_sshd
  include env_sudoers
  include env_firewall
  include env_clam
  include env_sysctl
  include env_lynis
  include env_rkhunter
  include env_fail2ban
  include env_aide
  include env_auditd

  package { 'git':
    ensure => present
  }

  package { 'yum-utils':
    ensure => present
  }

  package { 'psacct':
    ensure => present
  }

  exec { 'turn process accounting on':
    command => '/sbin/accton on',
    require => Package['psacct']
  }

  package { 'policycoreutils-python':
    ensure => present
  }

  augeas { "login_defs":
    context => "/files/etc/login.defs",
    changes => [
                 "set PASS_MAX_DAYS 9998",
                 "set PASS_MIN_DAYS 1",
                 "set FAILLOG_ENAB  yes"
               ]
  }

  exec { "profile":
    command => "/bin/sed -i 's/umask 0[02]2/umask 077/' /etc/profile"
  }

  exec { "init.d_functions":
    command => "/bin/sed -i 's/umask 0[02]2/umask 077/' /etc/init.d/functions"
  }

  exec { "bashrc":
    command => "/bin/sed -i 's/umask 0[02]2/umask 077/' /etc/bashrc"
  }

  exec { "csh.cshrc":
    command => "/bin/sed -i 's/umask 0[02]2/umask 077/' /etc/csh.cshrc"
  }

  file_line { "TMOUT_set_in_profile":
    path  => "/etc/profile",
    line  => "TMOUT=3600",
    match => "^TMOUT="
  }

  file_line { "TMOUT_readonly_in_profile":
    path => "/etc/profile",
    line => "readonly TMOUT"
  }

  file_line { "proc_hidepid":
    path   => "/etc/fstab",
    line   => "proc                    /proc                   proc    defaults,hidepid=2                     0 0",
    notify => Exec["remount_proc"]
  }

  exec { "remount_proc":
    command     => "/bin/mount -o remount /proc",
    refreshonly => 'true'
  }

  file { "modprobe.d_blacklist":
    ensure  => present,
    path    => "/etc/modprobe.d/blacklist.conf",
    content => [
      "blacklist firewire-ohci",
      "blacklist usb-storage",
      "install cramfs /bin/true",
      "install squashfs /bin/true",
      "install udf /bin/true"
    ].join("\n"),
    owner   => root,
    group   => root,
    mode    => '600'
  }

  # Compiler permissions - make sure not world executable

  file { '/usr/bin/as':
    mode    => '700'
  }

  file { '/usr/bin/gcc':
    mode    => '700'
  }

  cron { 'puppet-hieradata-pull':
    command => 'cd /etc/puppetlabs/code/environments/production/hieradata && git pull',
    user    => 'root',
    minute  => 0
  }

  cron { 'puppet-modules-pull':
    command => 'cd /etc/puppetlabs/code/environments/production/modules && git pull',
    user    => 'root',
    minute  => 0
  }

  cron { 'puppet-manifests-pull':
    command => 'cd /etc/puppetlabs/code/environments/production/manifests && git pull',
    user    => 'root',
    minute  => 0
  }

  cron { 'puppet-re-apply':
    command => '/usr/bin/systemctl restart rc-local',
    user    => 'root',
    minute  => 15
  }

  file { "/etc/rc.local set up":
    ensure  => present,
    path    => "/etc/rc.d/rc.local",
    content => [
      "#!/bin/bash",
      "# THIS FILE IS ADDED FOR COMPATIBILITY PURPOSES",
      "#",
      "# It is highly advisable to create own systemd services or udev rules",
      "# to run scripts during boot instead of using this file.",
      "#",
      "# In contrast to previous versions due to parallel execution during boot",
      "# this script will NOT be run after all other services.",
      "#",
      "# Please note that you must run 'chmod +x /etc/rc.d/rc.local' to ensure",
      "# that this script will be executed during boot.",
      "",
      "touch /var/lock/subsys/local",
      "",
      "# Initial set up of hostname for VMware machines",
      "which vmtoolsd 2> /dev/null",
      "if [ $? -eq 0 ]",
      "then",
      "  if [ \$(hostname|cut -d- -f1) != 'env' ]",
      "  then",
      "    new_ip=\$(vmtoolsd --cmd 'info-get guestinfo.ovfenv'|grep vCloud_ip_0|grep -o 10.21.1.[0-9]*)",
      "    new_host=\$(grep -B1 \$new_ip /etc/puppetlabs/code/environments/production/hieradata/common.yaml|head -n1|cut -d' ' -f3|cut -d: -f1)",
      "    new_host=\${new_host:1:-1}",
      "    hostname \$new_host",
      "    echo \$new_host > /etc/hostname",
      "  fi",
      "fi",
      "",
      "# Turn on process accounting",
      "/sbin/accton on",
      "",
      "# Run puppet manifest (which will cron running puppet manifest at quarter past every hour)",
      "export FACTERLIB=/opt/puppetlabs/facter/facts.d/",
      "/opt/puppetlabs/bin/puppet apply /etc/puppetlabs/code/environments/production/manifests/linux_manifest.pp"
    ].join("\n"),
    owner   => root,
    group   => wheel,
    mode    => '740'
  }
}
