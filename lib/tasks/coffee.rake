namespace :coffee do
  desc 'Watch coffeescript files'
  task :watch do
    system('coffee -wc -o public/javascripts app/coffeescripts/*.coffee')
  end
end