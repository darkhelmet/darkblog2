class PrerenderPages < ActiveRecord::Migration
  def up
    Page.reset_column_information
    Page.all.each(&:save!)
  end

  def down
  end
end
