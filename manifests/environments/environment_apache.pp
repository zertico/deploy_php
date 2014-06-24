#Class deploy_php::environments::environment_apache
#
class deploy_php::environments::environment_apache ( ) {

  apache::module { $deploy_php::apache_module:
    install_package => true,
  }

  $restart_service = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'apache2',
    default                   => 'httpd',
  }

  if $deploy_php::apache_module == 'suphp' {

    file {'/etc/suphp/suphp.conf':
      ensure  => present,
      content => template ($deploy_php::template_suphp_conf),
      require => Package["ApacheModule_${deploy_php::apache_module}"],
      notify  => Service[$restart_service],
    }

    file {'/etc/apache2/mods-available/suphp.conf':
      ensure  => present,
      content => template ($deploy_php::template_suphp_mod),
      require => Package["ApacheModule_${deploy_php::apache_module}"],
      notify  => Service[$restart_service],
    }

  }

}
