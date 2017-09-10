# Class: env_sshd
# ===========================
#
# Configure env_sshd
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
#    class { 'env_sshd':
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
class env_sshd {
  package { "openssh-server":
    ensure => "installed"
  }

  service { "sshd":
    ensure  => "running",
    enable  => "true",
    require => Package["openssh-server"]
  }
  
  $env_issue=lookup("env_issue",{})

  file { "env_issue":
    ensure  => file,
    path    => '/etc/issue',
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    content => $env_issue.join("\n")
  }

  file { "env_issue.net":
    ensure  => file,
    path    => '/etc/issue.net',
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    content => $env_issue.join("\n")
  }

  file { "env_motd":
    ensure  => file,
    path    => '/etc/motd',
    owner   => 'root',
    group   => 'root',
    mode    => '644',
    content => $env_issue.join("\n")
  }

  augeas { "configure_sshd":
    context => "/files/etc/ssh/sshd_config",
    changes => [
                 "set PasswordAuthentication no",
                 "set UsePam                 yes",
                 "set PermitRootLogin        no",
                 "set Banner /etc/issue.net",
                 "set AllowTcpForwarding     no",
                 "set ClientAliveCountMax    2",
                 "set Compression            no",
                 "set LogLevel               verbose",
                 "set MaxAuthTries           2",
                 "set MaxSessions            2",
                 "set TCPKeepAlive           no",
                 "set UseDNS                 no",
                 "set X11Forwarding          no",
                 "set AllowAgentForwarding   no"
               ],
    require => Package["openssh-server"],
    notify  => Service["sshd"]
  }
}
