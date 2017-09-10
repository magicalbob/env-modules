# Class: env_auditd
# ===========================
#
# Full description of class env_auditd here.
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
#    class { 'env_auditd':
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
class env_auditd {
  exec { 'auditd service config - remove default':
    command => '/bin/sed -i "s/^ExecStartPost=-\/sbin\/augenrules --load//" /etc/systemd/system/multi-user.target.wants/auditd.service'
  }

  exec { 'auditd service config - add custom':
    command => '/bin/sed -i "s/^#ExecStartPost=-\/sbin\/auditctl -R \/etc\/audit\/audit.rules/ExecStartPost=\/sbin\/auditctl -R \/etc\/audit\/audit.rules/" /etc/systemd/system/multi-user.target.wants/auditd.service',
    require => Exec['auditd service config - remove default']
  }

  $auditd_rules=lookup('auditd_rules',{})

  file { 'auditd rules.d':
    ensure  => file,
    path    => '/etc/audit/rules.d/audit.rules',
    owner   => 'root',
    group   => 'root',
    mode    => '600',
    content => $auditd_rules.join("\n")
  }
}
