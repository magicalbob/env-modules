# Class: env_rkhunter
# ===========================
#
# Full description of class env_rkhunter here.
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
#    class { 'env_rkhunter':
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
class env_rkhunter {
  package { 'rkhunter':
    ensure => 'installed'
  }

  exec { "rkhunter_exec":
    command => "/bin/rkhunter --update",
    returns => ['0','2']
  }

  cron { 'cron_rkhunter':
    name    => 'rkhunter',
    command => '/bin/rkhunter --versioncheck && /bin/rkhunter --update && /bin/rkhunter --propupd && /bin/rkhunter --cronjob --report-warnings-only',
    user    => 'root',
    hour    => 18,
    minute  => 00
  }
}
