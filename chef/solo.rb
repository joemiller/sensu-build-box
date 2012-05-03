root = File.expand_path(File.dirname(__FILE__))

unless File.exists?('/var/chef/cache/tmp')
  Dir.mkdir('/var/chef/cache/tmp')
end 
file_cache_path '/var/chef/cache/tmp'
cookbook_path root + '/cookbooks'
role_path root + '/roles'
