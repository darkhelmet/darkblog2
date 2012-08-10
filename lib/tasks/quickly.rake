Rake::TaskManager.class_eval do
  def replace_task(old_task, new_task)
    @tasks[old_task] = @tasks[new_task]
  end
end

desc 'Make tests run faster'
task :quickly do
  %w(db:test:load db:test:purge).each do |task|
    Rake.application.replace_task(task, 'quickly:nothing')
  end
end

namespace :quickly do
  task :nothing do
  end
end
