# Class: env_clam
# ===========================
#
# Full description of class env_clam here.
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
#    class { 'env_clam':
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
class env_clam {
  yumrepo { 'epel-release':
    mirrorlist => 'https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch',
    descr => 'Extra Packages for Enterprise Linux 7 - $basearch',
    enabled => 1,
    gpgcheck => 1,
    gpgkey => 'https://archive.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7'
  }

  package { "clamav-server":
    ensure => "installed"
  }

  package { "clamav-data":
    ensure => "installed"
  }

  package { "clamav-update":
    ensure => "installed"
  }

  package { "clamav-filesystem":
    ensure => "installed"
  }

  package { "clamav":
    ensure => "installed"
  }

  package { "clamav-scanner-systemd":
    ensure => "installed"
  }

  package { "clamav-devel":
    ensure => "installed"
  }

  package { "clamav-lib":
    ensure => "installed"
  }

  package { "clamav-server-systemd":
    ensure => "installed"
  }

  selboolean { "antivirus_can_scan_system":
    name       => "antivirus_can_scan_system",
    persistent => true,
    value      => on
  }

  selboolean { "clamd_use_jit":
    name       => "clamd_use_jit",
    persistent => true,
    value      => on
  }

  exec { "clam_not_example":
    command => 'sed -i -e "s/^Example/#Example/" /etc/clamd.d/scan.conf',
    path    => ['/bin', '/usr/bin', '/opt/puppetlabs/bin']
  }

  exec { "clam_socket":
    command => 'sed -i -e "s/^#LocalSocket/LocalSocket/" /etc/clamd.d/scan.conf',
    path    => ['/bin', '/usr/bin', '/opt/puppetlabs/bin']
  }

  exec { "freshclam_not_example":
    command => 'sed -i -e "s/^Example/#Example/" /etc/freshclam.conf',
    path    => ['/bin', '/usr/bin', '/opt/puppetlabs/bin']
  }

  service { 'clamd@scan':
    ensure => 'running',
    enable => true
  }

  cron { 'cron freshclam':
    command => 'freshclam -v',
    user    => 'root',
    hour    => 19,
    minute  => 0
  }
}
