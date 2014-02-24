# TODO: split off into separate module (or move to puppet master module)
# either way, it makes little sense to keep this in the puppet (agent) module
class puppet::dashboard (
  $environment    = $puppet::dashboard::params::environment,
  $database       = $puppet::dashboard::params::database,
  $username       = $puppet::dashboard::params::username,
  $password       = $puppet::dashboard::params::password,
  $host           = $puppet::dashboard::params::host,
  $max_report_age = $puppet::dashboard::params::max_report_age,) inherits puppet::dashboard::params {
  package { 'puppet-dashboard': ensure => installed, }

  file { '/etc/puppet-dashboard/database.yml':
    content => template('puppet/database.yml.erb'),
    require => Package['puppet-dashboard'],
    owner   => 'root',
    group   => 'www-data',
    mode    => '0660',
  }

  exec { "rake RAILS_ENV=${environment} db:migrate":
    command     => "rake RAILS_ENV=${environment} db:migrate",
    cwd         => '/usr/share/puppet-dashboard',
    require     => File['/etc/puppet-dashboard/database.yml'],
    subscribe   => File['/etc/puppet-dashboard/database.yml'],
    refreshonly => true,
  }

  # default logrotate installed by package seems to be misconfigured,
  # rotating the incorrect directory. (+we want added flexibility)
  file { '/etc/logrotate.d/puppet-dashboard':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('puppet/puppet-dashboard.logrotate.erb'),
  }

  file { '/etc/default/puppet-dashboard':
    content => "START=yes
DASHBOARD_HOME=/usr/share/puppet-dashboard
DASHBOARD_USER=www-data
DASHBOARD_RUBY=/usr/bin/ruby
DASHBOARD_ENVIRONMENT=${environment}
DASHBOARD_IFACE=127.0.0.1
DASHBOARD_PORT=3000",
    require => Package['puppet-dashboard'],
    mode    => '0660',
  }

  cron { 'puppet_optimize_database':
    command => "cd /usr/share/puppet-dashboard/ && rake RAILS_ENV=${environment} db:raw:optimize",
    user    => 'www-data',
    hour    => 1,
    minute  => 30,
    weekday => 0,
  }

  cron { 'puppet_delete_old_data':
    command => "cd /usr/share/puppet-dashboard/ && rake RAILS_ENV=${environment} reports:prune upto=${max_report_age} unit=day > /tmp/puppet_dashboard_prune.log 2>&1",
    user    => 'www-data',
    hour    => '*',
    minute  => 25,
    weekday => '*',
  }
}
