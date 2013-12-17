require 'bundler/capistrano'
load 'deploy/assets'

set :application, "one_click_orgs"
set :repository,  "git://github.com/oneclickorgs/one-click-orgs-deployment"

set :scm, :git
set :user, 'oneclickorgs'
set :use_sudo, false
set :sv, "/usr/bin/sv"
# set :rake, "/home/oneclickorgs/local/bin/bundle exec rake"
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

role :web, "parsnip.servers.oneclickorgs.com"                          # Your HTTP server, Apache/etc
role :app, "parsnip.servers.oneclickorgs.com"                          # This may be the same as your `Web` server
role :db,  "parsnip.servers.oneclickorgs.com", :primary => true # This is where Rails migrations will run

set :deploy_to, "/var/www/gov.oneclickorgs.com"
set :branch,    "gov-oneclickorgs-com"

set :bundle_dir, File.join(fetch(:shared_path), 'bundler')
# set :bundle_cmd, "~/local/bin/bundle"
set :bundle_roles, [:app]
set :bundle_flags, "--deployment --quiet --binstubs"

after 'deploy:update_code' do
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
