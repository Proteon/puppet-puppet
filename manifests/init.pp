# Class: puppet
#
# This module manages the puppet shared components (package and config)
#
# Parameters:
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class puppet (
  $confdir = $puppet::params::confdir,
  $logdir  = $puppet::params::logdir,
  $vardir  = $puppet::params::vardir,
  $ssldir  = $puppet::params::ssldir,
  $rundir  = $puppet::params::rundir,
  $ensure  = present) inherits puppet::params {
  package { 'puppet': ensure => $ensure, }

  Ini_setting {
    path    => "${confdir}/puppet.conf",
    section => 'main',
    ensure  => $ensure,
  }

  ini_setting { 'logdir':
    setting => 'logdir',
    value   => $logdir,
  }

  ini_setting { 'vardir':
    setting => 'vardir',
    value   => $vardir,
  }

  ini_setting { 'ssldir':
    setting => 'ssldir',
    value   => $ssldir,
  }

  ini_setting { 'rundir':
    setting => 'rundir',
    value   => $rundir,
  }
}
