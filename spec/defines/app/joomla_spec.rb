require 'spec_helper'

describe 'deploy_php::app::joomla::v1' do 
        let(:title){ 'example.com' }

        context 'installed in general(nginx/apache) environment' do
             it do should contain_file('/root/puppet/joomla/example.com').with({
                 'ensure' => 'directory',
                 'owner'  => 'root',
                 'group'  => 'root',  
             })
             end
             it { should contain_puppi__netinstall('netinstall_joomla_example.com')} 
	end
end
