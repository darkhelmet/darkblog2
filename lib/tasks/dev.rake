namespace :pg do
  desc 'start postgres'
  task :start do
    exec('postgres -D $HOME/opt/homebrew/var/postgres')
  end
end
