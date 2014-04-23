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
  $apache_module      = params_lookup ('apache_module'),
  $template_php_ini   = params_lookup('template_php_ini'),
  $template_suphp_conf	= params_lookup('template_suphp_conf'),
  $template_suphp_mod  	= params_lookup('template_suphp_mod')


  ) inherits deploy_php::params {

  include $deploy_php::webserver_name

	if $deploy_php::webserver_name == 'nginx' {
			include php5fpm
	} else {
			if $deploy_php::apache_module == 'suphp' or $deploy_php::apache_module == 'php5' {
					include deploy_php::environments::environment_apache
			}
	}
}
