namespace :db do
  File.expand_path('tmp/pids/mongod.pid').tap do |pidfile|
    desc 'start mongod'
    task :start do
      unless File.exists?(pidfile)
        log = Rails.root.join('log', 'mongodb.log')
        system('mongod', '--logpath', log.to_s, '--dbpath', Rails.root.join('db', 'mongodb').to_s, '--bind_ip', '127.0.0.1', '--fork', '--notablescan')
        sleep(1) # Let mongo start
        pid = File.read(log).split("\n").first.match(/pid=(\d+)/)[1]
        File.open(pidfile, 'w') { |f| f.write(pid) }
      end
    end

    desc 'stop mongod'
    task :stop do
      if File.exists?(pidfile)
        Process.kill('TERM', File.read(pidfile).to_i) rescue nil
        File.delete(pidfile) rescue nil
      end
    end
  end
end