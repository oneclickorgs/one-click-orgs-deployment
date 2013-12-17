require 'bundler/capistrano'
# load 'deploy/assets'

set :application, "one_click_orgs"
set :repository,  "git://github.com/oneclickorgs/one-click-orgs-deployment"

set :scm, :git
set :user, 'oneclickorgs'
set :use_sudo, false
set :sv, "/usr/bin/sv"
# set :rake, "/home/ubuntu/.rbenv/versions/1.9.3-p374/bin/bundle exec rake"
set :default_environment, {
  'PATH' => "$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
}

role :web, "oneclick.uk.coop"                          # Your HTTP server, Apache/etc
role :app, "oneclick.uk.coop"                          # This may be the same as your `Web` server
role :db,  "oneclick.uk.coop", :primary => true # This is where Rails migrations will run

set :deploy_to, "/var/www/oneclick.uk.coop"
set :branch,    "oneclick-uk-coop"

set :bundle_dir, File.join(fetch(:shared_path), 'bundler')
# set :bundle_cmd, "/home/ubuntu/.rbenv/versions/1.9.3-p374/bin/bundle"
set :bundle_roles, [:app]
set :bundle_flags, "--deployment --quiet --binstubs"

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

# PRECOMPILE ASSETS LOCALLY
# FROM http://www.rostamizadeh.net/blog/2012/04/14/precompiling-assets-locally-for-capistrano-deployment

before 'deploy:finalize_update', 'deploy:assets:symlink'
after 'deploy:update_code', 'deploy:assets:precompile'

namespace :deploy do
  namespace :assets do

    task :precompile, :roles => :web do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run_locally("rake assets:clean && rake assets:precompile")
        run_locally "cd public && tar -jcf assets.tar.bz2 assets"
        top.upload "public/assets.tar.bz2", "#{shared_path}", :via => :scp
        run "cd #{shared_path} && tar -jxf assets.tar.bz2 && rm assets.tar.bz2"
        run_locally "rm public/assets.tar.bz2"
        run_locally("rake assets:clean")
      else
        logger.info "Skipping asset precompilation because there were no asset changes"
      end
    end

    task :symlink, roles: :web do
      run ("rm -rf #{latest_release}/public/assets &&
            mkdir -p #{latest_release}/public &&
            mkdir -p #{shared_path}/assets &&
            ln -s #{shared_path}/assets #{latest_release}/public/assets")
    end
  end
end
