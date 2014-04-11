#
# = Class: deploy_php
#
# This class installs and manages deploy_php
#
#
# == Parameters
#
# Refer to https://github.com/stdmod for official documentation
# on the stdmod parameters used
#
class deploy_php (

  $webserver_name 		= params_lookup('webserver_name'),
  $servicephp_name 		= ''

  ) inherits deploy_php::params {


  $chosen_webserver = $webserver_name ? {
			''			=> undef,
			default => $deploy_php::webserver_name
  } 

  include $chosen_webserver		


	$chosen_servicephp = $servicephp_name ? {
			''			=> 'suphp',
			default => $deploy_php::servicephp_name
	}

	if $chosen_webserver == 'nginx' {
			include php5fpm
	} else {
			if $chosen_servicephp == 'suphp' or $chosen_servicephp == 'php5' {
					 apache::module { "${chosen_servicephp}":
					    install_package => true,
  				}	
			}
	}
}
