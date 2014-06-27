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
        let(:params) {{:webserver_name => 'apache' }}
	it do should contain_class('apache')
	end   
	it { should contain_class("deploy_php::environments::environment_apache") }
   end
   context 'testing apache and php5' do
	let(:params){{:webserver_name => 'apache',:apache_module => 'php5' }}
	it do should contain_class('apache')
	end
	it do should contain_class("deploy_php::environments::environment_apache")
	end	
   end
end

