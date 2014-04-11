module Puppet::Parser::Functions
  newfunction(:checkuser, :type => :rvalue) do |args|
    resultado_facter = args[0]
    user = args[1]
    basename = resultado_facter.split("\n").include?(user).to_s
  end
end