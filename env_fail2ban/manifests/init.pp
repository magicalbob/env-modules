# Class: env_fail2ban
# ===========================
#
# Full description of class env_fail2ban here.
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
#    class { 'env_fail2ban':
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
class env_fail2ban {
  package { "fail2ban":
    ensure => "installed"
  }

  service { "fail2ban":
    ensure  => "running",
    enable  => "true",
    require => Package["fail2ban"]
  }

  $jail_conf=lookup("jail_conf",{})

  file { "jail.conf":
    ensure  => file,
    path    => '/etc/fail2ban/jail.local',
    owner   => 'root',
    group   => 'root',
    mode    => '400',
    content => $jail_conf.join("\n")
  }
}
