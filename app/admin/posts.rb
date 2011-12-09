ActiveAdmin.register Post do
  scope :all, :default => true
  scope :unpublished
  scope :with_images

  index do |post|
    column :title do |post|
      link_to(post.title, edit_admin_post_path(post))
    end
    column :category do |post|
      post.category.humanize
    end
    column :description, sortable: false
    column 'Tags', :tag_string, sortable: false
    column 'Published?', :published, sortable: false do |post|
      post.published? ? 'Yes' : 'No'
    end
    column :published_on
    column 'Actions' do |post|
      ul do
        li link_to('Edit', edit_admin_post_path(post))
        li link_to('Delete', admin_post_path(post), :method => :delete, :confirm => 'Really delete?')
        if post.published?
          li link_to('Unpublish', unpublish_admin_post_path(post), :method => :put)
        else
          li link_to('Publish', publish_admin_post_path(post), :method => :put)
        end
      end
    end
  end

  filter :title, as: :string
  filter :category, as: :select, collection: -> { Post.categories }
  filter :published_on, as: :date_range
  filter :published, as: :select

  member_action :unpublish, method: :put do
    Post.find(params[:id]).unpublish!
    redirect_to(action: :index)
  end

  member_action :publish, method: :put do
    Post.find(params[:id]).publish!
    redirect_to(action: :index)
  end

  member_action :upload, method: :post do
    post = Post.find(params[:id])
    post.update_from_transloadit(JSON.parse(params[:transloadit]))
    redirect_to(action: :edit)
  end

  collection_action :clear_cache, method: :post do
    Rails.cache.clear
    redirect_to(action: :index)
  end

  form partial: 'form'

  sidebar :help do
    ul do
      li link_to('Textile Reference', 'http://redcloth.org/hobix.com/textile/')
      li link_to('Clear Cache', clear_cache_admin_posts_path, method: :post)
    end
  end
end
