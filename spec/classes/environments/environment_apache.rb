require 'spec_helper'

describe 'deploy_php::environments::environment_apache' do
     context 'with suphp as main module' do
	it do should contain_file('/etc/suphp/suphp.conf').with({
		'ensure'   => 'present',
		'notify'   => 'Service[apache2]'
	})
	end
	it do should contain_file('/etc/apache/mods-available/suphp.php').with({
		'ensure'  => 'present',
		'notify'  => 'Service[apache2]'
	})		
	end
     end
end

