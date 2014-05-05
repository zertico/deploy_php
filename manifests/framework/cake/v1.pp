define deploy_php::framework::cake::v1 (  
	$db_name = '',
	$db_user = '',
	$db_pass = '',	
	$directory = "/root/puppet/cake/${name}",
	$complete_path  = "/home/vhosts/${name}/public_html/",
  $random	 = fqdn_rand(1000000,"${name}"),
) {

 	
	file { "${directory}":
			ensure => directory,
			owner => "root",
			group => "root",
	}

 
	puppi::netinstall { "netinstall_cake_${name}":
		url => "https://github.com/cakephp/cakephp/zipball/2.4.9",
		extract_command	 => 'unzip',
		destination_dir	 => "${directory}/install",
		extracted_dir		 => ".",
		owner => "${name}",
		group => "${name}",
		preextract_command => "",
		postextract_command => "[ -d ${complete_path} ] || mkdir ${complete_path} && mv ${directory}/install/cakephp-cakephp-06714e9/* ${complete_path}",
		work_dir => "${directory}",
		require => File["${directory}"],
	}
 	
	
	file { "${complete_path}app/Config/core.php":   
		ensure  => present,
		owner		=> "${name}",
		group		=> "${name}",
	  content => template("deploy_php/framework/cake/core.php.erb"),
		require => puppi::netinstall["netinstall_cake_${name}"],
  }

  file { "${complete_path}app/Config/database.php":
		 ensure => present,
		 owner 	=> "${name}",
		 group	=> "${name}",	
		 content => template("deploy_php/framework/cake/database.php.erb"),
		 require => puppi::netinstall["netinstall_cake_${name}"],
  } 
 
  file { "${complete_path}.htaccess":
		ensure => present,
		content => template("deploy_php/framework/cake/htaccess"),
	  owner		=> "${name}",
		group		=> "${name}",
		require => Puppi::Netinstall["netinstall_cake_${name}"],
	}



}
