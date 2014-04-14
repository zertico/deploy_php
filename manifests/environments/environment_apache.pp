class deploy_php::environments::environment_apache (
		$webserver_php_conf_template = params_lookup ( 'deploy_php::apache::webserver_php_conf_template' ),
	  $apache_module 							 = params_lookup ( 'deploy_php::apache::apache_module' ),
		$template_php_ini    				 = params_lookup ( 'deploy_php::apache::template_php_ini' ),
	  $template_suphp_conf    		 = params_lookup ( 'deploy_php::apache::template_suphp_conf' ),
	  $template_suphp_mod  				 = params_lookup ( 'deploy_php::apache::template_suphp_mod' ),
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
    	content => template("${template_php_ini}"),
  	  ensure  => present,
	    require => Package["ApacheModule_php5"],
    	notify  => Service["apache2"],
  	}

	} elsif deploy_php::apache::apache_module == 'suphp' {
		
		file { "/etc/php5/cgi/php.ini":
    	content => template("${template_php_ini}"),
  	  ensure  => present,
	    require => Package["ApacheModule_suphp"],
    	notify  => Service["apache2"],
  	}

	  file {"/etc/suphp/suphp.conf":
  	  content => template("${template_suphp_conf}"),
    	ensure  => present,
	    require => Package["ApacheModule_suphp"],
  	  notify  => Service["apache2"],
  	}

  	file {"/etc/apache2/mods-available/suphp.conf":
    	content => template ("${template_suphp_mod}"),
    	ensure  => present,
    	require => Package["ApacheModule_suphp"],
    	notify  => Service["apache2"],
  	}
	}
}
