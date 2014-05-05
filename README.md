#deploy_php

####Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [Resources managed by deploy_php module](#resources-managed-by-deploy_php-module)
    * [Setup requirements](#setup-requirements)
    * [Beginning with module deploy_php](#beginning-with-module-deploy_php)
4. [Usage](#usage)
5. [Operating Systems Support](#operating-systems-support)
6. [Development](#development)

##Overview

This module installs, manages and configures deploy_php.

##Module Description

The module is based on **stdmod** naming standards version 0.9.0.

Refer to http://github.com/stdmod/ for complete documentation on the common parameters.

##Setup

###Resources managed by deploy_php module
* This module installs the deploy_php package
* Enables the deploy_php service
* Can manage all the configuration files (by default no file is changed)

###Setup Requirements
* PuppetLabs [stdlib module](https://github.com/puppetlabs/puppetlabs-stdlib)
* StdMod [stdmod module](https://github.com/stdmod/stdmod)
* Puppet version >= 2.7.x
* Facter version >= 1.6.2

###Beginning with module deploy_php

To install the package nginx package and php5-fpm provided by the module just include it:

```puppet
     include deploy_php
```

The main class arguments can be provided direct parameters to install apache and its modules:

```puppet
     class { 'deploy_php':
       	webserver_name => 'apache',
     }
		
		 OR
     
     class { 'deploy_php':
       	webserver_name => 'apache',
			  servicephp_name => 'suphp'
     }
```
##Usage

* A common way to use this module involves the deploy of wordpress:

```puppet
	deploy_php::apache { "example.com":
    	createdb                    => true,
	    mysql_database_name         => 'm_example',
	    mysql_password              => 'iyDPMHFBiwFX6',
	    mysql_user                  => 'm_example',
	    system_username_password    => 'ycG/UabGX1SSc',
	    application									=> 'wordpress'		
	} 

```

* A common way to use this module involves the deploy of cake_php:

```puppet
	deploy_php::apache { "example.com":
    	createdb                    => true,
	    mysql_database_name         => 'm_example',
	    mysql_password              => 'iyDPMHFBiwFX6',
	    mysql_user                  => 'm_example',
	    system_username_password    => 'ycG/UabGX1SSc',
	    framework									=> 'cake'		
	} 

```



##Operating Systems Support

This is tested on these OS:
- Debian 7

##Development

Pull requests (PR) and bug reports via GitHub are welcomed.

When submitting PR please follow these quidelines:
- Provide puppet-lint compliant code
- If possible provide rspec tests
- Follow the module style and stdmod naming standards

When submitting bug report please include or link:
- The Puppet code that triggers the error
- The output of facter on the system where you try it
- All the relevant error logs
- Any other information useful to undestand the context
