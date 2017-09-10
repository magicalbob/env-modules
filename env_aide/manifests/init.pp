# Class: env_aide
# ===========================
#
# Full description of class env_aide here.
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
#    class { 'env_aide':
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
class env_aide {
  package { 'aide':
    ensure => 'installed'
  }

  exec { 'aide init':
    command => '/sbin/aide --init',
    unless  => '/bin/ls /var/lib/aide/aide.db*',
    require => Package['aide']
  }

  exec { 'aide db rename':
    command => '/bin/mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz',
    unless  => '/bin/ls /var/lib/aide/aide.db.gz',
    require => Exec['aide init']
  }

  cron { 'aide check':
    command => 'aide --check',
    user    => 'root',
    hour    => 9,
    minute  => 0
  }
}
