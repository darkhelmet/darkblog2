require 'spec_helper'

describe "posts/show.html.haml" do
  before(:each) do
    @post = assign(:post, stub_model(Post,
      :title => "Title",
      :string => "",
      :body => "MyText",
      :published => false,
      :tags => "Tags",
      :slug => "Slug",
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain("Title".to_s)
    rendered.should contain("".to_s)
    rendered.should contain("MyText".to_s)
    rendered.should contain(false.to_s)
    rendered.should contain("Tags".to_s)
    rendered.should contain("Slug".to_s)
    rendered.should contain("Description".to_s)
  end
end
