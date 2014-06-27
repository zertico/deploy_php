require 'spec_helper'

describe 'deploy_php::app::wordpress::v1' do 
        let(:title){ 'example.com' }
	let(:params){{
	    :db      => 'm_example',
	    :db_user => 'm_example',
	    :db_pass => 'iyDPMHFBiwFX6', 
            :db_host => 'localhost', 		
	}}

        context 'installed in general(nginx/apache) environment' do
             it do should contain_file('/root/puppet/wordpress/example.com').with({
                 'ensure' => 'directory',
                 'owner'  => 'root',
                 'group'  => 'root',  
             })end
             it do should contain_file('/home/vhosts/example.com/public_html/wp-config.php').with({
                 'ensure'  => 'present',
                 'owner'   => 'example.com',
                 'group'   => 'example.com',
                 'replace' => 'false',
                 'mode'    => '0755', 
             })end

	end
end
