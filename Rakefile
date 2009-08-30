require 'rake'

namespace :thin do  
  
  desc "Start The Application"
  task :start do
    puts "Restarting The Application..."
  	system("thin -s 1 -C config/config.yml -R config/config.ru start")
  end  
  
  desc "Stop The Application"
  task :stop do
    puts "Stopping The Application..."
  	Dir.new("/home/me/webapps/todolist/tmp/pids").each do |file| 
           Thread.new do               
             prefix = file.to_s
             if prefix[0, 4] == 'thin'
               str  = "thin stop -Ptmp/pids/#{file}" 
               puts "Stopping server on port #{file[/\d+/]}..." 
               system(str)
             end 
           end 
         end
  end 
   
  desc "Restart The Application"
  task :restart do 
    puts "Restarting The Application..."
    [:stop, :start]                                               
  end  
end

task :deploy do
  puts "Deploying to server"
  system("rsync  --exclude 'db/todolist.sqlite3.db' --exclude 'tmp/**/*' -rltvz -e ssh . me@me.com:/home/me/webapps/todolist")
  require 'net/ssh'
  Net::SSH.start('me.com', 'me', :password => "mine") do |ssh|
    ssh.exec "cd /home/me/webapps/todolist && rake thin:restart"
  end  
end
  