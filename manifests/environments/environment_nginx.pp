class deploy_php::environments::environment_nginx {

	package { [	"libpcre3", 
							"php5-common", 
							"libmysqlclient-dev",
							"libmysqlclient18",
							"php5-mysql",
							"php5-gd", 
							"php5-curl", 
							"php5-mcrypt", 
							"php5-cli" ]:
		   
		ensure  => installed,
  }

}
