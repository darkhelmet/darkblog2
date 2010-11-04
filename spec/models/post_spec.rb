require 'spec_helper'

describe Post do
  describe "#find_by_permalink_params" do
    it "should return nil if nothing found" do
      Post.find_by_permalink_params(:day => '01', :year => '1900', :month => '01', :slug => 'nothing-to-see-here').should be_nil
    end
  end
end