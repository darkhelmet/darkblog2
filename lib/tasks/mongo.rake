namespace :db do
  File.expand_path('tmp/pids/mongod.pid').tap do |pidfile|
    desc 'start mongod'
    task :start do
      unless File.exists?(pidfile)
        log = Rails.root.join('log', 'mongodb.log')
        system('mongod', '--journal', '--logpath', log.to_s, '--dbpath', Rails.root.join('db', 'mongodb').to_s, '--bind_ip', '127.0.0.1', '--fork', '--notablescan', '--pidfilepath', pidfile)
      end
    end

    desc 'stop mongod'
    task :stop do
      if File.exists?(pidfile)
        Process.kill('TERM', File.read(pidfile).to_i) rescue nil
        sleep(2)
        File.delete(pidfile) rescue nil
      end
    end
  end

  desc 'Load production data'
  task :load_production => :environment do
    uri = URI(`heroku config --long | grep MONGOHQ | awk '{ print $3 }'`)
    conn = Mongo::Connection.new
    dev_db = Post.db.name
    conn.drop_database(dev_db)
    conn.copy_database(uri.path[1..-1], dev_db, "#{uri.host}:#{uri.port}", uri.user, uri.password)
    # FIXME: Can't find a way to repair form here, but it needs to happen.
    Admin.first.update_attributes(:password => 'admin', :password_confirmation => 'admin')
  end
end