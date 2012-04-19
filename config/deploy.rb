set :application, "personal"
set :repository,  "git://github.com/alno/site-personal.git"

set :user, "personal"
set :use_sudo, false
set :deploy_to, "/home/personal/apps/personal"

set :scm, :git

role :web, "alno.name"
role :app, "alno.name"
role :db,  "alno.name", :primary => true

require 'bundler/capistrano'

after "deploy:update_code", roles => :app do
  run "ln -s #{shared_path}/config/unicorn.rb #{release_path}/config/unicorn.rb"
  run "ln -s #{shared_path}/config/flickr.yml #{release_path}/config/flickr.yml"
  run "ln -s #{shared_path}/config/slideshare.yml #{release_path}/config/slideshare.yml"
end

namespace :deploy do

  desc "Restarting unicorn"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} ; ([ -f tmp/pids/unicorn.pid ] && kill -USR2 `cat tmp/pids/unicorn.pid`) || bundle exec unicorn -c config/unicorn.rb -E production -D"
  end

  desc "Rude restart application"
  task :rude_restart, :roles => :app do
    run "cd #{current_path} ; pkill unicorn; sleep 0.5; pkill -9 unicorn; sleep 0.5 ; bundle exec unicorn_rails -c config/unicorn.rb -E production -D "
  end

  task :start, :roles => :app do
    rude_restart
  end

end
