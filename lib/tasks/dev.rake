namespace :pg do
  desc 'start postgres'
  task :start do
    exec('postgres -D /usr/local/var/postgres')
  end
end
