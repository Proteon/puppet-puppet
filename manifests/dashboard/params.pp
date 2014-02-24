class puppet::dashboard::params {
  $environment = 'production'
  $database = 'puppet_dashboard'
  $username = 'puppet_dashboard'
  $password = 'puppet_dashboard'
  $host = 'localhost'
  $log_dir = '/usr/share/puppet-dashboard/log/' # seems to be the default
  $log_user = 'www-data'
  $log_group = 'www-data'
  $log_mode = '0640'
  $max_report_age = 30
}
