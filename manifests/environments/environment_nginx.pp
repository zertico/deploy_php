class deploy_php::environments::environment_nginx {

	package { [ "libpcre3", 
		    "php5-common", 
		    "libmysqlclient-dev",
		    "libmysqlclient18",
		    "php5-mcrypt"]:
		ensure  => installed,
	}

}
