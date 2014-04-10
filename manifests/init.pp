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
  $servicephp_name 		= params_lookup('servicephp_name'),
  $my_class           = undef,

  ) inherits deploy_php::params {


  $chosen_webserver = $webserver_name ? {
				'' 			=> "apache"
				default => $deploy_php::webserver_name	
  } 
	
	$chosen_servicephp = $servicephp_name ? {
				''			=>	"",
				default => $deploy_php::servicephp_name
	}

	include $chosen_webserver
	include $chosen_servicephp
}
