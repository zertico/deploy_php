require 'spec_helper'

describe "deploy_php::environments::environment_apache",:type => :class do
     context 'apache and suphp' do
	let :facts do
       {
       :osfamily => 'Debian',
       :operatingsystem => 'Debian',
       :operatingsystemrelease => '7.0',
       :kernel => 'Linux',
       }
       end
 
        let :pre_condition do
	    "class { 'deploy_php':
		webserver_name => 'apache',
		apache_module  => 'suphp'	
	    }"
  	end
	it { should contain_apache__module('suphp') }
	it do should contain_file('/etc/suphp/suphp.conf').with({
		'ensure'   => 'present',
	        'notify'   => 'Service[apache2]'
	})
	end
	it do should contain_file("/etc/apache2/mods-available/suphp.conf").with({
		'ensure'  => 'present',
		'notify'  => 'Service[apache2]'
	})		
	end
     end
    
     context 'apache and mod_php' do
	let :facts do
        {
         :osfamily => 'Debian',
         :operatingsystem => 'Debian',
         :operatingsystemrelease => '7.0',
         :kernel => 'Linux',
       }
       end

        let :pre_condition do
	   " class { 'deploy_php':
               webserver_name => 'apache',
               apache_module  => 'php5' 
             }
           "
        end
        it { should contain_apache__module('php5') }

     end	



end
