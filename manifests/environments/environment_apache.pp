class deploy_php::environments::environment_apache (
		$webserver_php_conf_template = params_lookup ( 'deploy_php::apache::webserver_php_conf_template' ),
	  $apache_module = params_lookup ( 'deploy_php::apache::apache_module' ),
) {

  package { [		'php5-mysql',
             		'php5-curl',
             		'php5-cli',
             		'php5-gd',
             ]:
    ensure => installed,
  }


	if $deploy_php::apache::apache_module == 'php5' {

		file { "/etc/php5/apache2/php.ini":
    	content => template("deploy_php/php.ini.erb"),
  	  ensure  => present,
	    require => Package["ApacheModule_php5"],
    	notify  => Service["apache2"],
  	}

	} elsif deploy_php::apache::apache_module == 'suphp' {
		
		file { "/etc/php5/cgi/php.ini":
    	content => template("deploy_php/php.ini.erb"),
  	  ensure  => present,
	    require => Package["ApacheModule_suphp"],
    	notify  => Service["apache2"],
  	}

	  file {"/etc/suphp/suphp.conf":
  	  content => template("deploy_php/suphp/suphp.conf"),
    	ensure  => present,
	    require => Package["ApacheModule_suphp"],
  	  notify  => Service["apache2"],
  	}

  	file {"/etc/apache2/mods-available/suphp.conf":
    	content => template ("deploy_php/suphp/suphp.conf-module"),
    	ensure  => present,
    	require => Package["ApacheModule_suphp"],
    	notify  => Service["apache2"],
  	}
	}
}
