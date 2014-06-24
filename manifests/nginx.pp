#Define deploy_php::nginx
#
define deploy_php::nginx (
  $createdb                      = true,
  $mysql_password                = '',
  $mysql_grantfilepath           = '/root/puppet/mysql',
  $mysql_database_name           = $name,
  $mysql_user                    = $name,
  $php_display_errors            = 'off',
  $php_log_errors                = 'off',
  $php_max_execution_time        = '0',
  $php_memory_limit              = '32M',
  $php_newrelic                  = false,
  $php_pm_max_children           = '5',
  $php_pm_max_requests           = '500',
  $php_pm_max_spare_servers      = '35',
  $php_pm_min_spare_servers      = '5',
  $php_pm_start_servers          = '20',
  $php_process_manager           = 'static',
  $php_request_slowlog_timeout   = '0',
  $system_create_user            = true,
  $system_user_homedir_mode      = '0711',
  $system_user_uid               = '',
  $system_user_tag               = 'vhosts',
  $system_username               = $name,
  $system_username_password      = absent,
  $webserver_aliases             = '',
  $webserver_documentroot        = "/home/vhosts/${name}/public_html/",
  $webserver_create_documentroot = true,
  $webserver_php                 = true,
  $webserver_php_conf_template   = 'deploy_php/nginx/php-short_open_tag-on.ini.erb',
  $webserver_phpfpm_template     = 'deploy_php/nginx/www-pool.conf.erb',
  $webserver_port                = '80',
  $webserver_redirect_www        = true,
  $webserver_site_priority       = '50',
  $webserver_template            = 'deploy_php/nginx/vhost.conf.erb',
  $application                   = ''
) {

  $bool_system_create_user      = any2bool($system_create_user)
  $real_mysql_database_name     = replacedot($mysql_database_name)

  if strlength($mysql_user) > 16 {
    $real_mysql_user = changelength(replacedot($mysql_user), '15')
  }  else {
    $real_mysql_user = replacedot($mysql_user)
  }

  if strlength($system_username) > 32 {
    $real_system_username_length = changelength($system_username, '31')
  }  else {
    $real_system_username_length = $system_username
  }

  $real_system_user_uid = $system_user_uid ? {
    ''      => absent,
    default => $system_user_uid,
  }

  $real_mysql_password = $mysql_password ? {
    ''      => $name,
    default => $mysql_password,
  }

  $real_system_username = $bool_system_create_user ? {
    false   => $real_system_username_length ? {
      $name  => 'www-data',
      default  => $real_system_username_length,
    },
    default => $real_system_username_length,
  }

  if $system_create_user == true  {

    user::managed { $real_system_username:
      name_comment     => $name,
      homedir          => "/home/vhosts/${name}",
      managehome       => true,
      password         => $system_username_password,
      password_crypted => false,
      uid              => $real_system_user_uid,
      homedir_mode     => $system_user_homedir_mode,
      tag              => $system_user_tag,
      password_salt    => '65941380',
      require          => File[$deploy_php::dir_path_webserver],
    }

    nginx::vhost { $name:
      template       => $webserver_template,
      docroot        => $webserver_documentroot,
      require        => User[$real_system_username],
      serveraliases  => $webserver_aliases,
      owner          => $real_system_username,
      groupowner     => $real_system_username,
      create_docroot => $webserver_create_documentroot,
      port           => $webserver_port,
      priority       => $webserver_site_priority,
    }

  }  else {

    nginx::vhost { $name:
      template       => $webserver_template,
      docroot        => $webserver_documentroot,
      serveraliases  => $webserver_aliases,
      owner          => $real_system_username,
      groupowner     => $real_system_username,
      create_docroot => $webserver_create_documentroot,
      port           => $webserver_port,
      priority       => $webserver_site_priority,
    }

  }

  if $webserver_php == true {

    require deploy_php::environments::environment_nginx
    php5fpm::config { $name:
      ensure                  => present,
      owner                   => $real_system_username,
      content                 => $webserver_phpfpm_template,
      display_errors          => $php_display_errors,
      log_errors              => $php_log_errors,
      memory_limit            => $php_memory_limit,
      max_execution_time      => $php_max_execution_time,
      process_manager         => $php_process_manager,
      pm_max_children         => $php_pm_max_children,
      pm_max_requests         => $php_pm_max_requests,
      pm_start_servers        => $php_pm_start_servers,
      pm_min_spare_servers    => $php_pm_min_spare_servers,
      pm_max_spare_servers    => $php_pm_max_spare_servers,
      request_slowlog_timeout => $php_request_slowlog_timeout,
    }

  }

  if $createdb == true {
    require mysql
    mysql::grant { $real_mysql_database_name:
      mysql_db             => $real_mysql_database_name,
      mysql_user           => $real_mysql_user,
      mysql_password       => $real_mysql_password,
      mysql_privileges     => 'ALL',
      mysql_host           => 'localhost',
      mysql_grant_filepath => $mysql_grantfilepath,
    }
  }

  if $application == 'wordpress' {
    deploy_php::app::wordpress::v1 { $real_system_username:
      db      => $real_mysql_database_name,
      db_user => $real_mysql_user,
      db_pass => $real_mysql_password,
      db_host => 'localhost',
      require => User::Managed [$real_system_username]
    }
  }

}
