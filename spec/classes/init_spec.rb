require 'spec_helper'

describe 'deploy_php' do
    context 'testing with nginx' do
	    let(:params) {{ :webserver_name => 'nginx' }}	
	    it do should contain_class('nginx') 
	    end
	    it do should contain_class('php5fpm')
	    end	
   end	
   context  'testing with apache and suphp' do 
        let(:params) {{:webserver_name => 'apache', :apache_module  => 'su_php' }}
	it do should contain_class('apache')
	end   
#	it { should contain_class('deploy_php::environments::environment_apache') }
	
   end
end

