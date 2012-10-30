require 'bundler/capistrano'
load 'deploy/assets'

set :application, "one_click_orgs"
set :repository,  "git://github.com/oneclickorgs/one-click-orgs-deployment"

set :scm, :git
set :user, 'ubuntu'
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa-oco")]
set :use_sudo, false
# set :sv, "~/local/bin/sv"
set :rake, "/usr/local/bin/bundle exec rake"
# default_environment["PATH"] = "/home/oneclickorgs/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/games"

role :web, "ec2-46-51-160-166.eu-west-1.compute.amazonaws.com"                          # Your HTTP server, Apache/etc
role :app, "ec2-46-51-160-166.eu-west-1.compute.amazonaws.com"                          # This may be the same as your `Web` server
role :db,  "ec2-46-51-160-166.eu-west-1.compute.amazonaws.com", :primary => true # This is where Rails migrations will run

set :deploy_to, "/var/www/conference.oneclickorgs.com"
set :branch,    "conference-coop-oneclickorgs-com"

set :bundle_dir, File.join(fetch(:shared_path), 'bundler')
set :bundle_cmd, "/usr/local/bin/bundle"
set :bundle_roles, [:app]

before 'deploy:assets:precompile' do
  run <<-END
    ln -sf #{shared_path}/config/database.yml #{release_path}/config/database.yml &&
    ln -sf #{shared_path}/config/initializers/local_settings.rb #{release_path}/config/initializers/local_settings.rb
  END
end

# after  "deploy:restart", "worker:restart"

# namespace :worker do
#   task :restart, :roles => :app do
#     run "for service in #{shared_path}/sv/*; do #{sv} restart $service || #{sv} kill $service; done"
#   end
# end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
