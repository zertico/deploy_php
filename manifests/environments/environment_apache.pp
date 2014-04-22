class deploy_php::environments::environment_apache (
  $module              = params_lookup ( 'module' ),
  $options             = params_lookup ( 'options' ),
  $template_php_ini    = params_lookup ( 'template_php_ini' ),
  $template_suphp_conf = params_lookup ( 'template_suphp_conf' ),
  $template_suphp_mod  = params_lookup ( 'template_suphp_mod' ),
  ) {

  $real_module = $deploy_php::zrtcserver::apache_php::module ? {
    ''      => "suphp",
    default => "php5",
  }

  $real_package = $deploy_php::zrtcserver::apache_php::module ? {
    'php5'    => "libapache2-mod-php5",
    default   => "libapache2-mod-suphp",
  }

  $real_template_php_ini = $deploy_php::zrtcserver::apache_php::template_php_ini ? {
    ''        => "deploy_php/suphp/php.ini.erb",
    default   => "${deploy_php::zrtcserver::apache_php::template_php_ini}",
  }

  $real_template_suphp_conf = $deploy_php::zrtcserver::apache_php::template_suphp_conf ? {
    ''        => "deploy_php/suphp/suphp.conf",
    default   => "${deploy_php::zrtcserver::apache_php::template_suphp_conf}",
  }

  $real_template_suphp_mod = $deploy_php::zrtcserver::apache_php::template_suphp_mod ? {
    ''        => "deploy_php/suphp/suphp.conf-module",
    default   => "${deploy_php::zrtcserver::apache_php::template_suphp_mod}",
  }

  package { [ 'php5-mysql',
               'php5-curl',
               'php5-cli',
               'php5-gd',
             ]:
    ensure => installed,
  }

  file { "/etc/php5/cgi/php.ini":
    content => template ("${real_template_php_ini}"),
    ensure  => present,
    require => Package["ApacheModule_${real_module}"],
    notify  => Service["apache2"],
  }

  if $real_module == "suphp" {

    file {"/etc/suphp/suphp.conf":
      content => template ("${real_template_suphp_conf}"),
      ensure  => present,
      require => Package["ApacheModule_${real_module}"],
      notify  => Service["apache2"],
    }

    file {"/etc/apache2/mods-available/suphp.conf":
      content => template ("${real_template_suphp_mod}"),
      ensure  => present,
      require => Package["ApacheModule_${real_module}"],
      notify  => Service["apache2"],
    }

  }

}
