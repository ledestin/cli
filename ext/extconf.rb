[
  "/etc/bash_completion.d",
  "/usr/local/etc/bash_completion.d"
].each do |dirname|
  if Dir.exists?(dirname)
    `cp #{File.expand_path(File.dirname(__FILE__))}/ninefold #{dirname}`
    break
  end
end

# stuff
require 'mkmf'
create_makefile('')
