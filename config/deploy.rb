load 'deploy/assets'
require 'bundler/capistrano'

set :application, "one_click_orgs"
set :repository,  "git://github.com/oneclickorgs/one-click-orgs-deployment"

set :scm, :git
set :user, 'oneclickorgs'
set :use_sudo, false
set :sv, "~/local/bin/sv"
set :rake, "/home/oneclickorgs/local/bin/bundle exec rake"

role :web, "us1.okfn.org"                          # Your HTTP server, Apache/etc
role :app, "us1.okfn.org"                          # This may be the same as your `Web` server
role :db,  "us1.okfn.org", :primary => true # This is where Rails migrations will run

set :deploy_to, "/home/oneclickorgs/var/www/dev.oneclickorgs.com"
set :branch,    "dev-oneclickorgs-com"

set :bundle_dir, File.join(fetch(:shared_path), 'bundler')
set :bundle_cmd, "~/local/bin/bundle"
set :bundle_roles, [:app]

after 'deploy:update_code' do
  run <<-END
    ln -sf #{shared_path}/config/database.yml #{release_path}/config/database.yml &&
    ln -sf #{shared_path}/config/initializers/local_settings.rb #{release_path}/config/initializers/local_settings.rb
  END
end

after  "deploy:restart",     "worker:restart"

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
