class puppet::master::webserver::webrick {

    service { 'puppetmaster':
        ensure    => running,
        enable    => true,
        hasstatus => true,
        provider  => 'upstart',
        require   => Package['puppetmaster'],
    }

    Ini_setting {
        path    => "${puppet::confdir}/puppet.conf",
        section => 'master',
        ensure  => $puppet::ensure,
    }

    package { 'puppetmaster':
        ensure  => $puppet::ensure,
        require => Apt::Source['puppetlabs']
    }
}
