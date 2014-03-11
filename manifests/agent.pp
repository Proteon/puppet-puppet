class puppet::agent (
  $server      = $puppet::agent::params::server,
  $runinterval = $puppet::agent::params::runinterval) inherits puppet::agent::params {
  include puppet

  Ini_setting {
    path    => "${puppet::confdir}/puppet.conf",
    section => 'agent',
    ensure  => $puppet::ensure,
  }

  ini_setting { 'server':
    setting => 'server',
    value   => $server,
  }

  ini_setting { 'runinterval':
    setting => 'runinterval',
    value   => $runinterval,
  }

  file { '/etc/default/puppet':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => 'START=yes
DAEMON_OPTS=""',
    require => Package['puppet']
  }
}
