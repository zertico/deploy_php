require 'spec_helper'

describe 'deploy_php' do
    context 'creates nginx environment' do
	    let(:params) {{ :webserver_name => 'nginx' }}	
	    it do should contain_class('nginx') 
	    end
	    it do should contain_class('php5fpm')
	    end	
   end	
   context  'creates apache and suphp environment' do 
        let(:params) {{:webserver_name => 'apache',:apache_module => 'suphp' }}
	it do should contain_class('apache')
	end   
	it do should contain_class("deploy_php::environments::environment_apache") 
	end
   end
   context 'creates apache and php5 environment' do
	let(:params){{:webserver_name => 'apache',:apache_module => 'php5' }}
	it do should contain_class('apache')
	end
	it do should contain_class("deploy_php::environments::environment_apache")
	end	
   end
end

