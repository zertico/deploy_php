#Define deploy_php::app::joomla::v1
#
define deploy_php::app::joomla::v1 (
  $url               = 'http://joomlacode.org/gf/download/frsrelease/19239/158104/Joomla_3.2.3-Stable-Full_Package.zip',
  $complete_path     = "/home/vhosts/${name}/public_html/",
  $directory         = "/root/puppet/joomla/${name}",
  $typeOfCompression = 'zip'
){

  $real_typeOfCompression  = $typeOfCompression ? {
    'zip'    => 'unzip',
    'tar.gz' => 'tar --strip-components 1 -zxf'
  }


  file { $directory:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
  }

  puppi::netinstall { "netinstall_joomla_${name}":
    url                 => $url,
    extract_command     => $real_typeOfCompression,
    destination_dir     => "${directory}/install",
    extracted_dir       => '.',
    owner               => $name,
    group               => $name,
    preextract_command  => '',
    postextract_command => "[ -d ${complete_path} ] || mkdir ${complete_path} && mv ${directory}/install/* ${complete_path}",
    work_dir            => $directory,
    require             => File[$directory],
  }
}
