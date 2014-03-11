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
  $reporturl                = undef) inherits puppet::master::params {
  include puppet

  package { 'puppetmaster': ensure => $puppet::ensure, }

  Ini_setting {
    path    => "${puppet::confdir}/puppet.conf",
    section => 'master',
    ensure  => $puppet::ensure,
  }

  ini_setting { 'bindaddress':
    setting => 'bindaddress',
    value   => $bindaddress,
  }

  ini_setting { 'ssl_client_header':
    setting => 'ssl_client_header',
    value   => $ssl_client_header,
  }

  ini_setting { 'ssl_client_verify_header':
    setting => 'ssl_client_verify_header',
    value   => $ssl_client_verify_header,
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
}
