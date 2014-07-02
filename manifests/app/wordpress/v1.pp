#Define deploy_php::app::wordpress::v1
#
define deploy_php::app::wordpress::v1 (
  $db,
  $db_user,
  $db_pass,
  $db_host,
  $user_name      = $title,
  $complete_path  = "/home/vhosts/${name}/public_html/",
  $directory      = "/root/puppet/wordpress/${name}",
  $groups         = $title,
  $url            = 'http://wordpress.org/latest.tar.gz',
  $typeOfCompression  = 'tar.gz'
) {

  $auth_key         = sha1("auth_key${name}")
  $secure_auth_key  = sha1("secure_auth_key${name}")
  $logged_in_key    = sha1("logged_in_key${name}")
  $nonce_key        = sha1("nonce_key${name}")
  $auth_salt        = sha1("auth_salt${name}")
  $secure_auth_salt = sha1("secure_auth_salt${name}")
  $logged_in_salt   = sha1("logged_in_salt${name}")
  $nonce_salt       = sha1("nonce_salt${name}")

  $real_typeOfCompression  = $typeOfCompression ? {
    'zip'    => 'unzip',
    'tar.gz' => 'tar --strip-components 1 -zxf'
  }

  file { $directory:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  puppi::netinstall { "netinstall_wordpress_${user_name}":
    url                 => $url,
    extract_command     => $real_typeOfCompression,
    destination_dir     => "${directory}/install",
    extracted_dir       => '.',
    owner               => $user_name,
    group               => $user_name,
    preextract_command  => '',
    postextract_command => "[ -d ${complete_path} ] || mkdir ${complete_path} && mv ${directory}/install/* ${complete_path}",
    work_dir            => $directory,
    require             => File[$directory],
  }

  file { "${complete_path}wp-config.php":
    ensure  => present,
    content => template('deploy_php/wordpress/wp-config.php.erb'),
    mode    => '0755',
    owner   => $user_name,
    group   => $user_name,
    replace => false,
    require => Puppi::Netinstall["netinstall_wordpress_${user_name}"],
  }

}
