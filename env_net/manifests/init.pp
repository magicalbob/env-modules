# Class: env_net
# ===========================
#
# Full description of class hosts here.
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
#    class { 'env_net':
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
class env_net {
  exec { 'Remove bogus ifcfg content':
    command => '/usr/bin/rm -vf /etc/sysconfig/network-scripts/ifcfg-eth0',
    onlyif  => [
                '/usr/bin/grep "check_link_down()" /etc/sysconfig/network-scripts/ifcfg-eth0'
               ]
  }

  network_config { 'eth0':
    ensure    => 'present',
    method    => 'static',
    onboot    => 'true',
    ipaddress => hiera('hosts')[$hostname]['ip'],
    netmask   => '255.255.255.0',
    require   => Exec['Remove bogus ifcfg content']
  }

  exec { 'network-gateway':
    command => '/usr/bin/echo GATEWAY=10.0.0.1 >> /etc/sysconfig/network-scripts/ifcfg-eth0',
    unless  => [
                '/usr/bin/grep GATEWAY= /etc/sysconfig/network-scripts/ifcfg-eth0'
               ]
  }

  exec { 'network-dns1':
    command => '/usr/bin/echo DNS1=10.0.0.1 >> /etc/sysconfig/network-scripts/ifcfg-eth0',
    unless  => [
                '/usr/bin/grep DNS1= /etc/sysconfig/network-scripts/ifcfg-eth0'
               ]
  }

  exec { 'network-dns2':
    command => '/usr/bin/echo DNS2=10.0.0.2 >> /etc/sysconfig/network-scripts/ifcfg-eth0',
    unless  => [
                '/usr/bin/grep DNS2= /etc/sysconfig/network-scripts/ifcfg-eth0'
               ]
  }

  exec { 'network-restart':
    command => '/usr/bin/systemctl restart network',
    onlyif  => [
                '/usr/bin/which vmtoolsd'
               ]
  }

  exec { 'network-route':
    command => '/usr/sbin/ip route add default via 10.0.0.1 dev eth0',
    unless  => [
                '/usr/sbin/ip route|/usr/bin/grep ^default'
               ]
  }
}
