# Class: deploy_php::params
#
# Defines all the variables used in the module.
#
class deploy_php::params {

  $webserver_name     = 'nginx'
  $dir_path_webserver = '/home/vhosts'
  $apache_module      = 'suphp'
  $template_php_ini   = 'deploy_php/php.ini.erb'
  $template_suphp_conf  = 'deploy_php/suphp/suphp.conf'
  $template_suphp_mod   = 'deploy_php/suphp/suphp.conf-module'

  file { $dir_path_webserver:
    ensure => directory,
  }

  file { ['/root/puppet/','/root/puppet/wordpress']:
    ensure => directory,
  }

  package { ['php5-mysql','php5-curl','php5-cli','php5-gd']:
    ensure => installed,
  }

}
