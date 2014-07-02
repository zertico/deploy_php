require 'spec_helper'
describe 'deploy_php::apache' do
  let(:title) { 'example.com' }
  context 'creates user,apache vhost and database' do
    let :params do 
    {
     :createdb                 => true,
     :mysql_database_name      => 'm_example',
     :mysql_password           => 'iyDPMHFBiwFX6',
     :mysql_user               => 'm_example',
     :system_username_password => 'ycG/UabGX1SSc'
    }
    end
    it { should contain_user__managed('example.com') }
    it { should contain_apache__virtualhost('example.com') }
    it { should contain_mysql__grant('m_example') }
  end
  context 'creates only user and apache vhost' do
   let :params do
   {
    :createdb                  => false,
    :system_username_password  => 'ycG/UabGX1SSc'  
   }
   it { should contain_user__managed('example.com') }
   it { should contain_apache__virtualhost('example.com')}
   end
  end
  context 'creates only apache vhost' do
     let :params do
     {
       :createdb           => false,
       :system_create_user => false, 
     }
     end
     it { should contain_apache__virtualhost('example.com')}
  end
end
