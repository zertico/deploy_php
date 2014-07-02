require 'spec_helper_acceptance'

describe 'deploy_apache define' do
	describe 'running wordpress' do
		it 'should install wordpress with no errors' do
			pp = <<-EOS
			class { 'deploy_php':
                            webserver_name => 'apache',
			}
                        deploy_php::apache { 'example.com':
                         createdb => true,
                         mysql_database_name => 'm_example',
                         mysql_password => 'iyDPMHFBiwFX6',
                         mysql_user =>'m_example',
                         system_username_password => 'ycG/UabGX1SSc',
                         application => 'wordpress'
                       }
			EOS
		        apply_manifest(pp, :catch_failures => true)
			expect(apply_manifest(pp).exit_code).to eq(0)
		end	
	describe 'created user and database' do
		it 'should create a user' do
			shell("cat /etc/passwd | grep example.com | sed -e 's/:.*//g'", :acceptable_exit_codes => 0)
		end

		it 'should create a database' do
			shell("ls /var/lib/mysql/ | grep m_example", :acceptable_exit_codes => 0)
		end
	end
    end
end
