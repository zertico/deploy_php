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
  $webserver_name       = $deploy_php::webserver_name,
  $apache_module        = $deploy_php::apache_module,
  $template_php_ini     = $deploy_php::template_php_ini,
  $template_suphp_conf  = $deploy_php::template_suphp_conf,
  $template_suphp_mod   = $deploy_php::template_suphp_mod
) inherits deploy_php::params {

  include $webserver_name

  if $deploy_php::webserver_name == 'nginx' {
    include php5fpm
  } else {
    if $deploy_php::apache_module == 'suphp' or $deploy_php::apache_module == 'php5' {
      class { 'deploy_php::environments::environment_apache': }
    }
  }

}
