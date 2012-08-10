require 'spec_helper'

describe Post do
  context 'class' do
    before :all do
      @categories = %w(foo bar)
      @tags = %w(a b c d e f g h)
      @published = 15.times.map { |i| create(:post, published_on: i.days.ago, category: @categories.rotate!.first, tags: @tags.rotate!.take(2)) }
      @unpublished = 5.times.map { create(:post, published: false, category: @categories.rotate!.first, tags: @tags.rotate!.take(2)) }
    end

    after :all do
      Post.delete_all
    end

    it 'should find_for_main_page' do
      Post.find_for_main_page.should eq(@published.take(6))
    end

    it 'should find_by_permalink_params' do
      post = @published.sample
      year, month, day = post.published_on.strftime('%Y.%m.%d').split('.')
      params = { slug: post.slug, year: year, month: month, day: day }
      Post.find_by_permalink_params(params).should eq(post)
    end

    it 'should find_by_category' do
      Post.find_by_category('foo').should eq(@published.select { |post| post.category == 'foo' })
    end

    it 'should find_by_month' do
      post = @published.sample
      date = post.published_on
      year, month = date.strftime('%Y.%m').split('.')
      params = { year: year, month: month }
      posts = @published.select do |post|
        pub = post.published_on
        pub.year == date.year && pub.month == date.month
      end
      Post.find_by_month(params).should eq(posts)
    end

    it 'should find_for_sitemap' do
      Post.find_for_sitemap.should eq(@published)
    end

    it 'should search_by_keywords' do
      Post.find_by_keywords('test').should eq(@published)
    end

    it 'should find_for_feed' do
      Post.find_for_feed.should eq(@published.take(10))
    end

    it 'should find_by_tag' do
      Post.find_by_tag('f').should eq(@published.select { |post| post.tags.include?('f') })
    end
  end

  context 'instance' do
    context 'slug' do
      it 'should replace slug when not published'
      it 'should append slug when published'
      it 'should use latest slug when published'
      it 'should use latest slug when not published'
    end

    context 'tags' do
      before :all do
        @tags = %w(foo bar)
      end

      it 'should get a tag string' do
        post = Post.new(tags: @tags)
        post.tag_string.should eq('foo, bar')
      end

      it 'should set a tag string' do
        post = Post.new
        post.tag_string = 'foo, bar'
        post.tags.should eq(@tags)
      end

      it 'should set tags' do
        post = Post.new
        post.tags.should eq([])
        post.tags = %w(foo bar bar)
        post.tags.should eq(@tags)
      end

      it 'should get tags' do
        post = Post.new(tags: @tags)
        post.tags.should eq(@tags)
      end
    end
  end
end
