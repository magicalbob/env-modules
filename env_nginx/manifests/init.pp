# Class: env_nginx
# ===========================
#
# Full description of class env_nginx here.
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
#    class { 'env_nginx':
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
class env_nginx {
  yumrepo { 'nginx':
    baseurl => 'http://nginx.org/packages/centos/$releasever/$basearch/',
    descr => 'nginx repo',
    enabled => 1,
    gpgcheck => 1,
    gpgkey => 'https://nginx.org/keys/nginx_signing.key'
  }

  package { 'nginx':
    ensure => present
  }

  file { 'nginx home owner':
    path    => '/var/cache/nginx',
    owner   => 'nginx',
    require => Package['nginx']
  }

  file { 'nginx_default_remove':
    ensure  => absent,
    path    => '/etc/nginx/conf.d/default.conf',
    require => Package['nginx']
  }

  $web_sites = lookup({ 'name' => 'web_sites', 'default_value' => {} })
  $web_sites.each | $web_site | {
    $server_name=$web_site[1][0]['server_name']
    $key_pairs=lookup({ 'name' => 'key_pairs', 'default_value' => {} })
    $key_file=$key_pairs[$web_site[1][0]['key_pair']][0]['key_file']
    $key=$key_pairs[$web_site[1][0]['key_pair']][0]['key']
    $crt_file=$key_pairs[$web_site[1][0]['key_pair']][0]['crt_file']
    $crt=$key_pairs[$web_site[1][0]['key_pair']][0]['crt']
    $locations=$web_site[1][0]['locations'].join("\n")

    $web_config=[
      "  server {",
      "  listen 443 ssl ;",
      "  server_name ${server_name};",
      "",
      "  ssl_certificate ${crt_file};",
      "  ssl_certificate_key ${key_file};",
      "",
      "  access_log /var/log/nginx/${server_name}_access.log;",
      "  error_log  /var/log/nginx/${server_name}_error.log;",
      "",
      "${locations}",
      "}"
    ].join("\n")

    file { "test_data_${server_name}":
      ensure   => present,
      path     => "/etc/nginx/conf.d/${server_name}.conf",
      content  => $web_config
    }

    file { "key_file_${server_name}":
      ensure   => present,
      path     => "$key_file",
      content  => $key
    }

    file { "crt_file_${server_name}":
      ensure   => present,
      path     => "$crt_file",
      content  => $crt
    }
  }

  file { "web_content_dir":
    ensure  => directory,
    path    => "/srv/www",
    owner   => nginx,
    group   => nginx,
    mode    => '0700'
  }

  file { "web_content_virtual":
    ensure  => directory,
    path    => "/srv/www/virtual",
    owner   => nginx,
    group   => nginx,
    mode    => '0700'
  }

  $web_contents = lookup({ 'name' => 'web_contents', 'default_value' => {} })
  $web_contents.each | $web_content | {
    $target_dir=$web_content[1][0]['target_dir']
    $target_git=$web_content[1][0]['git']
    vcsrepo { "$target_dir":
      ensure   => present,
      provider => git,
      source   => $target_git,
      user     => 'nginx',
      require  => Exec['nginx restorecon']
    }
  }

  file { "basic_auth_dir":
    ensure  => directory,
    path    => "/etc/nginx/passwd",
    owner   => nginx,
    group   => nginx,
    mode    => '700'
  }

  $basic_auth = lookup({ 'name' => 'basic_auth', 'default_value' => {} })
  $basic_auth.each | $auth_basic | {
    file { "$auth_basic[1][0]['user_file']":
      ensure  => present,
      path    => $auth_basic[1][0]['user_file'],
      content => $auth_basic[1][0]['user_cont'],
      owner   => nginx,
      group   => nginx,
      mode    => '700'
    }
  }

  service { 'nginx':
    ensure => 'running'
  }
}
