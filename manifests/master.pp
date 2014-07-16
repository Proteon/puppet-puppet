class puppet::master (
  $bindaddress              = $puppet::master::params::bindaddress,
  $ssl_client_header        = $puppet::master::params::ssl_client_header,
  $ssl_client_verify_header = $puppet::master::params::ssl_client_verify_header,
  $autosign                 = $puppet::master::params::autosign,
  $external_nodes           = $puppet::master::params::external_nodes,
  $node_terminus            = $puppet::master::params::node_terminus,
  $modulepath               = undef, 
  $factpath                 = $puppet::master::params::factpath,
  $templatedir              = $puppet::master::params::templatedir,
  $reports                  = undef,
  $reporturl                = undef,
  $webserver                = $puppet::master::params::webserver) inherits puppet::master::params {
  include puppet

  $ensure_3_6_0 = versioncmp($::puppetversion, '3.5.9') ? {
    '0'       => present,
    '-1'      => present,
    '1'       => absent,
    default   => present,
  }

  if(versioncmp($::puppetversion, '3.5.9') > 0) {
    file { ["${puppet::confdir}/environments",
            "${puppet::confdir}/environments/production", 
            "${puppet::confdir}/environments/production/manifests",
            "${puppet::confdir}/environments/production/modules"
            ]:
        ensure => directory,
    }
    ini_setting { 'master_environmentpath':
      setting => 'environmentpath',
      value   => '$confdir/environments',
    }
    ini_setting { 'master_modulepath':
      setting => 'modulepath',
      ensure  => absent,
    }
  }

  Ini_setting {
    path    => "${puppet::confdir}/puppet.conf",
    section => 'master',
    ensure  => $puppet::ensure,
  }

  ini_setting { 'bindaddress':
    setting => 'bindaddress',
    value   => $bindaddress,
  }

  ini_setting { 'autosign':
    setting => 'autosign',
    value   => $autosign,
  }

  ini_setting { 'factpath':
    setting => 'factpath',
    value   => $factpath,
  }

  ini_setting { 'templatedir':
    setting => 'templatedir',
    value   => $templatedir,
    ensure  => $ensure_3_6_0,
  }

  if ($external_nodes != '') {
    ini_setting { 'external_nodes':
      setting => 'external_nodes',
      value   => $external_nodes,
    }

    ini_setting { 'node_terminus':
      setting => 'node_terminus',
      value   => $node_terminus,
    }
  }

  if $modulepath {
    notify { 'Deprecation notice: puppet::master::modulepath is deprecated, use puppet::modulepath instead': }
  }

  if $reports {
    notify { 'Deprecation notice: puppet::master::reports is deprecated, use puppet::reports instead': }
  }

  if $reporturl {
    notify { 'Deprecation notice: puppet::master::reporturl is deprecated, use puppet::reporturl instead': }
  }

  class { "puppet::master::webserver::${webserver}": }
}
