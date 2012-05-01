require 'rake'

desc "run librarian-chef to pull down all cookbooks"
task :chef_prep do
  ## install librarian manually instead of with bundler due to this:
  ##  https://github.com/applicationsonline/librarian/issues/35
  unless Gem.available? 'librarian'
    sh "gem install librarian --no-rdoc --no-ri --quiet"
  end
  sh "cd chef && librarian-chef update"
end
