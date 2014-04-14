# Class: deploy_php::params
#
# Defines all the variables used in the module.
#
class deploy_php::params {

  $webserver_name = 'nginx'
  $dir_path_webserver = '/home/vhosts'
 
 	file { "${dir_path_webserver}":
				ensure => directory
  } 
 
  file { ["/root/puppet/","/root/puppet/wordpress"]:
			ensure => directory,		
  }


 

}
