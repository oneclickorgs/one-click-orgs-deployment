set :application, "one_click_orgs"
set :repository,  "git://github.com/oneclickorgs/one-click-orgs"

set :scm, :git

role :web, "us1.okfn.org"                          # Your HTTP server, Apache/etc
role :app, "us1.okfn.org"                          # This may be the same as your `Web` server
role :db,  "us1.okfn.org", :primary => true # This is where Rails migrations will run

set :deploy_to, "/home/oneclickorgs/var/www/#{instance_name}"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
