class puppet::master::webserver::unicorn (
    $worker_processes  = 8,
    $working_directory = '/usr/share/puppet/ext/rack/',
    $listen            = '\'/var/run/puppet/puppetmaster_unicorn.sock\', :backlog => 512',
    $pid               = '/var/run/puppet/puppetmaster_unicorn.pid') {

    package { 'puppetmaster':
        ensure  => 'absent',
        require => Apt::Source['puppetlabs']
    }

    if (!defined(Package['rubygems'])) {
        package { 'rubygems': ensure => installed, }
    }

    ::nginx::site { "${::fqdn}_8140":
        listen_port      => '*:8140',
        listen_options   => 'default_server ssl',
        default_location => false,
    }

    ::nginx::location { "${::fqdn}_8140":
        site_name              => "${::fqdn}_8140",
        location               => '/',
        proxy                  => "http://unix:/var/run/puppet/puppetmaster_unicorn.sock",
        proxy_set_header       => [
        { 'Host'            => '$host' },
        { 'X-Real-IP'       => '$remote_addr' },
        { 'X-Forwarded-For' => '$proxy_add_x_forwarded_for' },
        { 'X-Client-Verify' => '$ssl_client_verify' },
        { 'X-Client-DN'     => '$ssl_client_s_dn' },
        { 'X-SSL-Issuer'    => '$ssl_client_i_dn' }
        ]
    }

    ::concat::fragment { "nginx error handling for ${::fqdn}_8140":
        target  => "/etc/nginx/sites-available/${::fqdn}_8140.conf",
        order   => "${::fqdn}_8140-02",
        content => "
ssl_certificate /var/lib/puppet/ssl/certs/${::fqdn}.pem;
ssl_certificate_key /var/lib/puppet/ssl/private_keys/${::fqdn}.pem;
ssl_client_certificate /var/lib/puppet/ssl/ca/ca_crt.pem;
ssl_ciphers SSLv2:-LOW:-EXPORT:RC4+RSA;
ssl_verify_client optional;
" 
    }


#    ::nginx::server::location { 'default':
#    server           => "${::fqdn}_8140",
#    location         => '/',
#    proxy_pass       => 'http://unix:/var/run/puppet/puppetmaster_unicorn.sock',
#    proxy_redirect   => 'off',
#    proxy_set_header => [
#    { 'Host'            => '$host' },
#    { 'X-Real-IP'       => '$remote_addr' },
#    { 'X-Forwarded-For' => '$proxy_add_x_forwarded_for' },
#    { 'X-Client-Verify' => '$ssl_client_verify' },
#    { 'X-Client-DN'     => '$ssl_client_s_dn' },
#    { 'X-SSL-Issuer'    => '$ssl_client_i_dn' }
#    ]
#    }

#    ::nginx::server::ssl { "${::fqdn}_8140":
#        server                 => "${::fqdn}_8140",
#        ssl_certificate        => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
#        ssl_certificate_key    => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
#        ssl_client_certificate => '/var/lib/puppet/ssl/ca/ca_crt.pem',
#        ssl_ciphers            => 'SSLv2:-LOW:-EXPORT:RC4+RSA',
#        ssl_verify_client      => 'optional',
#    }

    exec { 'install-puppet-gem':
        command => "/usr/bin/gem install puppet --version ${::puppetversion} --no-ri --no-rdoc",
        unless  => "/usr/bin/gem list | grep 'puppet (' |grep ${::puppetversion}",
        require => Package['rubygems'],
    }

    ::unicorn::instance { 'puppetmaster':
        worker_processes  => $worker_processes,
        working_directory => $working_directory,
        listen            => $listen,
        pid               => $pid,
        user              => 'puppet',
    }

    Ini_setting {
        path    => "${puppet::confdir}/puppet.conf",
        section => 'master',
        ensure  => $puppet::ensure,
    }

    ini_setting { 'ssl_client_header':
        setting => 'ssl_client_header',
        value   => 'HTTP_X_CLIENT_DN',
    }

    ini_setting { 'ssl_client_verify_header':
        setting => 'ssl_client_verify_header',
        value   => 'HTTP_X_CLIENT_VERIFY',
    }
}
