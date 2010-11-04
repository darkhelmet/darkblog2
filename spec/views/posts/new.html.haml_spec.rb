require 'spec_helper'

describe "posts/new.html.haml" do
=begin
  before(:each) do
    assign(:post, stub_model(Post,
      :new_record? => true,
      :title => "MyString",
      :string => "",
      :body => "MyText",
      :published => false,
      :tags => "MyString",
      :slug => "MyString",
      :description => "MyString"
    ))
  end

  it "renders new post form" do
    render

    rendered.should have_selector("form", :action => posts_path, :method => "post") do |form|
      form.should have_selector("input#post_title", :name => "post[title]")
      form.should have_selector("input#post_string", :name => "post[string]")
      form.should have_selector("textarea#post_body", :name => "post[body]")
      form.should have_selector("input#post_published", :name => "post[published]")
      form.should have_selector("input#post_tags", :name => "post[tags]")
      form.should have_selector("input#post_slug", :name => "post[slug]")
      form.should have_selector("input#post_description", :name => "post[description]")
    end
  end
=end
end
