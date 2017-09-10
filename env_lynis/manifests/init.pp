# Class: env_lynis
# ===========================
#
# Full description of class env_lynis here.
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
#    class { 'env_lynis':
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
class env_lynis {
  yumrepo { 'lynis':
    baseurl => 'https://packages.cisofy.com/community/lynis/rpm/
',
    descr => 'CISOfy Software - Lynis package',
    enabled => 1,
    gpgcheck => 1,
    gpgkey => 'https://packages.cisofy.com/keys/cisofy-software-rpms-public.key'
  }

  yum::install { 'lynis':
    ensure => present,
    source => 'lynis'
  }

  cron { 'lynis audit system':
    command => '/bin/lynis audit system',
    user    => 'root',
    hour    => 2,
    minute  => 0,
  }
}
