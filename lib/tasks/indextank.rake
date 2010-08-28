namespace :indextank do
  task :setup do
    "#{Darkblog2.config[:search_index]}-#{Rails.env}".tap do |index|
      IndexTank::HerokuClient.new.add_index(index) rescue nil
      IndexTank::HerokuClient.new.get_index(index).add_function(0, 'relevance')
    end
  end
end