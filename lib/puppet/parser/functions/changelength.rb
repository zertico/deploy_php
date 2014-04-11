module Puppet::Parser::Functions
    newfunction(:changelength, :type => :rvalue) do |args|
       username = args[0].to_s[0..args[1].to_i]
       username[0..args[1].to_i]
    end
end