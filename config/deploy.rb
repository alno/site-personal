set :application, "personal"
set :repository,  "git://github.com/alno/site-personal.git"

set :user, "hosting_alno"
set :use_sudo, false
set :deploy_to, "/home/hosting_alno/projects/personal"

set :scm, :git

role :web, "hydrogen.locum.ru"
role :app, "hydrogen.locum.ru"
role :db,  "hydrogen.locum.ru", :primary => true

set :bundle, "/var/lib/gems/1.8/bin/bundle"
set :unicorn, "/var/lib/gems/1.8/bin/unicorn"
set :unicorn_conf, "/etc/unicorn/personal.alno.rb"
set :unicorn_pid, "/var/run/unicorn/personal.alno.pid"

after "deploy:update_code", :bundle_deps
after "deploy:update_code", :copy_configs

task :bundle_deps, roles => :app do
  run "cd #{release_path} && #{bundle} install --path ~/.gem --without development test"
end

task :copy_configs, roles => :app do
  run "cp #{deploy_to}/shared/flickr.yml #{release_path}/config"
  run "cp #{deploy_to}/shared/slideshare.yml #{release_path}/config"
end

namespace :deploy do
  desc "Start application"
  task :start, :roles => :app do
    run "cd #{deploy_to}/current && #{bundle} exec #{unicorn} -Dc #{unicorn_conf}"
  end

  desc "Stop application"
  task :stop, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -QUIT `cat #{unicorn_pid}`"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "[ -f #{unicorn_pid} ] && kill -USR2 `cat #{unicorn_pid}` || (cd #{deploy_to}/current && #{bundle} exec #{unicorn} -Dc #{unicorn_conf})"
  end
end
