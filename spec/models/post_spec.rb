require 'spec_helper'

describe Post do
  describe '#find_by_permalink_params' do
    it 'should return nil if nothing found' do
      Post.find_by_permalink_params(:day => '01', :year => '1900', :month => '01', :slug => 'nothing-to-see-here').should be_nil
    end
  end

  describe '#group_by_month' do
    it 'should group by month' do
      3.times { |i| Factory(:post, :published_on => i.months.ago) }
      Post.count.should == 3
      groups = Post.group_by_month
      groups.length.should == 3
    end
  end
end