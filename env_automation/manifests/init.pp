# Class: env_automation
# ===========================
#
# Full description of class env_automation here.
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
#    class { 'env_automation':
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
define env_automation (String $user_name = 'root') {
  $user_dir=$user_home[$user_name]
  $ssh_path="$user_dir/.ssh"
  $key_path="$user_dir/.ssh/id_rsa"
  $kno_path="$user_dir/.ssh/known_hosts"

  file { "ssh_dir_${user_name}":
    ensure  => directory,
    path    => $ssh_path,
    owner   => $user_name,
    group   => $user_name,
    mode    => '0700'
  }

  file { "key_file_${user_name}":
    ensure  => file,
    path    => $key_path,
    owner   => $user_name,
    group   => $user_name,
    mode    => '600',
    content => lookup('env-automation.key').join("\n")
  }

  file { "known_host_${user_name}":
    ensure  => file,
    path    => $kno_path,
    owner   => $user_name,
    group   => $user_name,
    mode    => '600',
    content => lookup('env-automation.known_host')
  }
}
