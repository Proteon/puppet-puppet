class puppet::params {
  $confdir = '/etc/puppet'
  $logdir = '/var/log/puppet'
  $vardir = '/var/lib/puppet'
  $ssldir = '/var/lib/puppet/ssl'
  $rundir = '/var/run/puppet'
  $factpath = '$vardir/lib/facter'
  $templatedir = '$confdir/templates'
  $modulepath = '$confdir/modules'
  $ignorecache = true
  $use_cached_catalog = false
  $usecacheonfailure = false
}
