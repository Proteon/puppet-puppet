class puppet::master::params {
  $bindaddress = '*'
  $ssl_client_header = 'SSL_CLIENT_S_DN'
  $ssl_client_verify_header = 'SSL_CLIENT_VERIFY'
  $autosign = true
  $external_nodes = undef
  $node_terminus = 'exec'
  $factpath = '$vardir/lib/facter'
  $templatedir = '$confdir/templates'
}
