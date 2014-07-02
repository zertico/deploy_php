require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

hosts.each do |host|
  # Install Puppet
  install_puppet
  install_package host, 'git-core'
end

RSpec.configure do |c|
  # Project root
  proj_root    = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'deploy_php')
    hosts.each do |host|
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, 'git clone  https://github.com/netmanagers/puppet-nginx.git /etc/puppet/modules/nginx'
      on host, 'git clone  https://github.com/example42/puppi.git /etc/puppet/modules/puppi'	
      on host, 'git clone  git://github.com/zertico/puppet-php5fpm.git /etc/puppet/modules/php5fpm'	
      on host, 'git clone  git://github.com/example42/puppet-apache.git /etc/puppet/modules/apache'	
      on host, 'git clone  git://github.com/example42/puppet-mysql.git /etc/puppet/modules/mysql'	
      on host, 'git clone git://github.com/example42/puppet-user.git /etc/puppet/modules/user'	
     end
  end
end
