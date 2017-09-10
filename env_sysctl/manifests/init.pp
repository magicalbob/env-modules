# Class: env_sysctl
# ===========================
#
# Full description of class env_sysctl here.
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
#    class { 'env_sysctl':
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
class env_sysctl {
  include env_sysctl_load

  $sysctl_data = lookup('sysctl_data',{})
  $sysctl_set = $sysctl_data.map | $sc_data | {
    "set /files/etc/sysctl.conf/${sc_data}"
  }

  augeas { "sysctl.conf":
    changes => $sysctl_set,
    notify  => Exec['sysctl_load']
  }
}

class env_sysctl_load {
  exec { "sysctl_load":
    command => "/sbin/sysctl -p"
  }
}
