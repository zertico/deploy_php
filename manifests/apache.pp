define deploy_php::apache (
  $createdb                      = true,
  $mysql_password                = '',
  $mysql_database_name           = "${name}",
  $mysql_user                    = "${name}",
  $mysql_grantfilepath           = '/root/puppet/mysql',
  $system_create_user            = true,
  $system_user_homedir_mode      = '0711',
  $system_user_uid               = '',
  $system_user_tag               = 'vhosts',
  $system_username               = "${name}",
  $system_username_password      = absent,
  $webserver_aliases             = '',
  $webserver_documentroot        = "/home/vhosts/${name}/public_html/",
  $webserver_create_documentroot = true,
  $webserver_php                 = true,
  $webserver_php_conf_template   = 'deploy_php/php.ini.erb',
  $webserver_suphp_conf_template = 'deploy_php/suphp/suphp.conf',
  $webserver_template            = 'virtualhost.conf.erb',
  $webserver_template_path       = "deploy_php/apache", 
	$apache_module								 = params_lookup('deploy_php::servicephp_name'),	
	$application									 = ''
	) {

  $bool_system_create_user=any2bool($system_create_user)
  $real_mysql_database_name = replacedot("${mysql_database_name}")

  if strlength($mysql_user) > 16 {
	  $real_mysql_user = changelength(replacedot("${mysql_user}"), '15')
  } else {
	  $real_mysql_user = replacedot($mysql_user)
  }

  if strlength($system_username) > 32 {
	  $real_system_username_length = changelength($system_username, '31')
  } else {
	  $real_system_username_length = $system_username
  }

  $real_system_user_uid = $system_user_uid ? {
    ''      => 'absent',
    default => $system_user_uid,
  }

  $real_mysql_password = $mysql_password ? {
    ''      => "${name}",
    default => $mysql_password,
  }

  $real_system_username = $bool_system_create_user ? {
    false   => $real_system_username_length ? {
      "$name"  => 'www-data',
      default  => "${real_system_username_length}",
    },
    default => "${real_system_username_length}",
  }

  $real_webserver_template_path = $webserver_template ? {
    "virtualhost.conf.erb" => "deploy_php/apache",
    default => "hosts/$fqdn/apache",
  }

  if $system_create_user == true {
    user::managed { "${real_system_username}":
      name_comment     => "${name}",
      homedir          => "/home/vhosts/${name}",
      managehome       => 'true',
      password         => "${system_username_password}",
      password_crypted => false,
      uid              => "${real_system_user_uid}",
      homedir_mode     => "${system_user_homedir_mode}",
      tag              => "${system_user_tag}",
      password_salt    => "65941380",
    }

    apache::virtualhost { "${name}":
      aliases        => "www.${name} $webserver_aliases",
      documentroot   => "$webserver_documentroot",
      require        => User["${real_system_username}"],
      owner          => "${real_system_username}",
      groupowner     => "${real_system_username}",
      templatepath   => "${real_webserver_template_path}",
      templatefile   => "${webserver_template}",
      create_docroot => "${webserver_create_documentroot}",
    }
  } else {
    apache::virtualhost { "${name}":
      aliases        => "www.${name} $webserver_aliases",
      documentroot   => "$webserver_documentroot",
      templatepath   => "${webserver_template_path}",
      templatefile   => "${webserver_template}",
      owner          => "${real_system_username}",
      groupowner     => "${real_system_username}",
      create_docroot => "${webserver_create_documentroot}",
    }
  }
 
  if $webserver_php == true {
    require deploy_php::environments::environment_apache
  }

  if $createdb == true {
    
    require mysql

    mysql::grant { "${real_mysql_database_name}":
      mysql_db             => "${real_mysql_database_name}",
      mysql_user           => "${real_mysql_user}",
      mysql_password       => "${real_mysql_password}",
      mysql_privileges     => 'ALL',
      mysql_host           => 'localhost',
      mysql_grant_filepath => "${mysql_grantfilepath}",
    }
  }

		if $application == 'wordpress' {
			deploy_php::app::wordpress::v1 { "${real_system_username}":
	  	  db      => "${real_mysql_database_name}",
	    	db_user => "${real_mysql_user}",
	    	db_pass => "${real_mysql_password}",
	    	db_host => 'localhost',
			}
	}




}
