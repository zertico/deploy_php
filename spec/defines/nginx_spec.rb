 require 'spec_helper'

describe 'deploy_php::nginx' do
   let(:title)  { 'example.com' } 
   context 'creates user,nginx vhost and database' do
       let :params do 
       {
           :createdb                    => true,
           :mysql_database_name         => 'm_example',
           :mysql_password              => 'iyDPMHFBiwFX6',
           :mysql_user                  => 'm_example',
           :system_username_password    => 'ycG/UabGX1SSc',
       }
       end
       it { should contain_user__managed('example.com') }
       it { should contain_nginx__vhost('example.com') }
       it { should contain_mysql__grant('m_example') }
   end
   context 'creates only user and nginx vhost' do
       let :params do 
       {
        :createdb                 => false,
        :system_username_password => 'ycG/UabGX1SSc'
       }
      end
      it { should contain_user__managed('example.com') }
      it { should contain_nginx__vhost('example.com')  }
   end
   context 'creates only nginx vhost' do
       let :params do 
       {
        :createdb => false,
        :system_create_user => false,       
       }
       end
       it { should contain_nginx__vhost('example.com') }
   end
end
