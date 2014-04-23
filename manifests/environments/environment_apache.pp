class deploy_php::environments::environment_apache ( ) {

  apache::module { "${deploy_php::apache_module}":
		    install_package => true,
  }

  if $deploy_php::apache_module == "suphp" {

    file {"/etc/suphp/suphp.conf":
      content => template ("${deploy_php::template_suphp_conf}"),
      ensure  => present,
      require => Package["ApacheModule_${deploy_php::apache_module}"],
      notify  => Service["apache2"],
    }

    file {"/etc/apache2/mods-available/suphp.conf":
      content => template ("${deploy_php::template_suphp_mod}"),
      ensure  => present,
      require => Package["ApacheModule_${deploy_php::apache_module}"],
      notify  => Service["apache2"],
    }

  }

}
