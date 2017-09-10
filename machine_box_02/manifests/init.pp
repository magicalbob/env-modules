# Class: machine_env_dev_jenkins
# ===========================
#
# Full description of class machine_env_dev_jenkins here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. 'Specify one or more upstream ntp servers as an array.'
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. 'The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames.' (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'machine_env_dev_jenkins':
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
class machine_env_dev_jenkins {
  include jenkins
  include env_nginx

  $jenkins_port = lookup({ 'name' => 'jenkins::config_hash.JENKINS_PORT', 'default_value' => { 'value' => 8080 } })['value']

  exec { 'nginx selinux port':
    command => "/usr/sbin/semanage port -a -t http_port_t -p tcp $jenkins_port",
    returns => ['0','1']
  }
}
