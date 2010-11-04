require 'spec_helper'

describe "posts/index.html.haml" do
=begin
  before(:each) do
    assign(:posts, [
      stub_model(Post,
        :title => "Title",
        :string => "",
        :body => "MyText",
        :published => false,
        :tags => "Tags",
        :slug => "Slug",
        :description => "Description"
      ),
      stub_model(Post,
        :title => "Title",
        :string => "",
        :body => "MyText",
        :published => false,
        :tags => "Tags",
        :slug => "Slug",
        :description => "Description"
      )
    ])
  end

  it "renders a list of posts" do
    render
    rendered.should have_selector("tr>td", :content => "Title".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyText".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => false.to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Tags".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Slug".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "Description".to_s, :count => 2)
  end
=end
end
