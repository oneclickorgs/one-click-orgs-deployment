require 'bundler/capistrano'
load 'deploy/assets'

set :application, "one_click_orgs"
set :repository,  "git://github.com/oneclickorgs/one-click-orgs-deployment"

set :scm, :git
set :user, 'oneclickorgs'
set :use_sudo, false
set :sv, "/usr/bin/sv"
set :rake, "/home/ubuntu/.rbenv/versions/1.9.3-p374/bin/bundle exec rake"
# default_environment["PATH"] = "/home/oneclickorgs/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/games"

role :web, "oneclick.uk.coop"                          # Your HTTP server, Apache/etc
role :app, "oneclick.uk.coop"                          # This may be the same as your `Web` server
role :db,  "oneclick.uk.coop", :primary => true # This is where Rails migrations will run

set :deploy_to, "/var/www/oneclick.uk.coop"
set :branch,    "oneclick-uk-coop"

set :bundle_dir, File.join(fetch(:shared_path), 'bundler')
set :bundle_cmd, "/home/ubuntu/.rbenv/versions/1.9.3-p374/bin/bundle"
set :bundle_roles, [:app]

before 'deploy:assets:precompile' do
  run <<-END
    ln -sf #{shared_path}/config/database.yml #{release_path}/config/database.yml &&
    ln -sf #{shared_path}/config/initializers/local_settings.rb #{release_path}/config/initializers/local_settings.rb
  END
end

after  "deploy:restart", "worker:restart"

namespace :worker do
  task :restart, :roles => :app do
    run "for service in #{shared_path}/sv/*; do #{sv} restart $service || #{sv} kill $service; done"
  end
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
