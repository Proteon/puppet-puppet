puppet-puppet
=============

This module configures a puppet agent, puppet master or puppet dashboard.

Basic usage
-------------------------
To set up a puppet installation without a puppet master (masterless) 

  include puppet

Parameters can be set using hiera or by defining them like this

  class { 'puppet':
    modulepath => '/opt/puppet/modules:$confdir/modules',
  }

Agent setup
-------------------------
To configure an puppet agent to use with a puppet master

  class { 'puppet::agent':
    server => 'puppetmaster-01.example.com',
  }

Master setup
-------------------------
To set up a basic puppet master

  include puppet::master

A master can also be configured to have an agent aboard, easiest is to configure them both with hiera and just include them both in your site.pp

  include puppet::agent
  include puppet::master
