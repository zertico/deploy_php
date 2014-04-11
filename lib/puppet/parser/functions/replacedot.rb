module Puppet::Parser::Functions
  newfunction(:replacedot, :type => :rvalue) do |args|
    basename = args[0].to_s  
    basename.gsub(/\.|\-/, '_')
    end
end